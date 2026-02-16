# Setup an SSH Remote Server on DigitalOcean

Since I use 1Password on my MacBook I could easily create a new SSH key and then upload the public key to Digital Ocean. However, since this is not always an option, I'm going to manually create the SSH keys in a Linux VM running in VMware Fusion.

## Generate SSH Keys

```bash
ssh-keygen -t ed25519 -C "First Key" -f ~/.ssh/id_ed25519_1st
ssh-keygen -t ed25519 -C "Second Key" -f ~/.ssh/id_ed25519_2nd
```

- Creates a pair of public and private ssh keys in the user's home directory inside the `.ssh` directory
- `-t` specifies the algorithm and `-C` a comment; `-f` is for the output filename

## Add SSH public Key

- While creating the Droplet I was able to add the first public SSH key

## Connect to the Droplet

```bash
ssh -i id_ed25519_1st root@your_droplet_ip
```

## Linux Droplet Security Hardening

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
chmod 600 .ssh/authorized_keys
chown -R devops:devops .ssh/authorized_keys
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
sudo ufw enable
```

### Add only the rules you need

```bash
sudo ufw allow ssh
```

### Display ufw status

```bash
devops@ubuntu-s-1vcpu-512mb-10gb-fra1-01:~$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
```

- We could change also default port 22 to say 2220 but a port scanner could easily find that out
- Security through obscurity isn't really secure

## Copy the second Public Key to the Remote Machine

```bash
ssh-copy-id -f -i ~/.ssh/id_ed25519_2nd.pub \
  -o IdentityFile=~/.ssh/id_ed25519_1st \
  devops@your_droplet_ip
```

- Adds our public key inside the `authorized_keys` file on remote host

## Add Host to config File on the localhost

```
Host droplet
	HostName your_droplet_ip
	User devops
```

- Allows us to run `ssh -i id_ed25519_1st droplet`
- No need to specify IP address or username repeatedly

## Passphrase Caching (optional, if you've set a passphrase)

```bash
eval $(ssh-agent)
ssh-add
```

- `eval $(ssh-agent)` starts the SSH agent and configures the shell to use it
- `ssh-add` loads private SSH key into the agent, enabling passwordless auth for the session
