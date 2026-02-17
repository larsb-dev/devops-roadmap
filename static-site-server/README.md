# nginx Static Site Server

## Generate SSH Keys

- I reused the SSH key from previous project [ssh-remote-server](https://github.com/larsb-dev/devops-roadmap/tree/main/ssh-remote-server)

## Add SSH public Key

- While creating the Droplet I was able to add my public SSH key

## Connect to the Droplet

```bash
ssh -i id_ed25519_1st root@your_droplet_ip
```

## Linux Droplet Security Hardening

- Again, we want to make our system more secure

### Update Your System

After your first successful SSH login, you should start by updating the package repository and upgrading the installed packages:

```bash
apt update && apt upgrade -y
```

### Create a Non-Root User

Running everything as `root` is risky. Create a regular admin user and add it to the sudo group:

```bash
adduser devops
usermod -aG sudo devops
```

### Setting up SSH for the new admin user

If you create a new non-root user, SSH key authentication won't work until you set up their `~/.ssh/authorized_keys` properly.

#### Create the .ssh directory and set correct permissions

```bash
su - devops
mkdir .ssh
chmod 700 .ssh
```

- We log in as the user devops, create .ssh directory and set rwx only for this user

#### Copy your root authorized_keys

```bash
sudo cp /root/.ssh/authorized_keys .ssh/
sudo chmod 600 .ssh/authorized_keys
sudo chown -R devops:devops .ssh/authorized_keys
```

### Test login in a new session before disabling root access

```bash
ssh devops@your_droplet_ip
```

## Secure SSH

Now, since the new admin user can SSH into the Linux VM and is part of the sudo group, we can lock down root SSH access.

### Edit SSH config

```bash
sudo nano /etc/ssh/sshd_config
```

### Disable RootLogin and PasswordAuthentication

```bash
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

### Restart SSH service

```bash
sudo systemctl restart ssh
```

Open another terminal session and try logging in as root. It shouldn't work aynmore!

## Enable a Basic Firewall

DigitalOcean Droplets usually come with ufw pre-installed by default, but you can also install the package manually:

```bash
sudo apt install ufw
```

### Reset ufw

This removes all rules, disables UFW, and restores the defaults. You'll see a warning that all rules will be deleted. Confirm with y:

```bash
sudo ufw reset
```

### Check Status

This should show `Status: inactive` with no rules:

```bash
sudo ufw status verbose
```

### Block all inbound traffic

This blocks all incoming connections except ones you explicitly allow. Don't worry, you won't be kicked out of your current SSH session, ufw is smart enough:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

### Add only the rules you need

```bash
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

### Display ufw status

```bash
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
443                        ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
443 (v6)                   ALLOW IN    Anywhere (v6)
80/tcp (v6)                ALLOW IN    Anywhere (v6)
```

## Let's Encrypt SSL/TLS Certificate for https

### Install Certbot

```bash
sudo apt install certbot python3-certbot-nginx
```

### Add nginx server block for your domain

```bash
cd /etc/nginx/sites-available
echo "server_name yourdomain.com www.yourdomain.com;" | sudo tee yourdomain.com
```

- Certbot needs to be able to find the correct server block in your Nginx configuration for it to be able to automatically configure SSL

### Verify nginx config

```bash
sudo nginx -t
```

### Restart nginx

```bash
sudo systemctl reload nginx
```

### Finally, let's obtain a Certificate

```bash
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

- Before running this command I had to add a DNS A record for my domain which points to this nginx server
- Important: Port 80 needs to be open during obtaining a certificate!!!

### Let's remove http from firewall rules

```bash
sudo ufw delete allow http
```

### The site is live 🎉

https://azurecloudlab.com/

- The site might be down for cost reasons as you're reading this

## Rsync

And now finally to the actual topic of this project 😅

```bash
rsync -a webpage/ nginx:/var/www/html
```

- This will sync all files inside the webpage directory to the html folder

## Edit SSH config file

```bash
Host nginx
    HostName your_droplet_ip
    User devops
    IdentityFile ~/.ssh/id_ed25519_1st
```

## Resources

- [How To Secure Nginx with Let's Encrypt on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-20-04)
- [How To Use Rsync to Sync Local and Remote Directories](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories)
