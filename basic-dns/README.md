# Basic DNS Setup

## DNS for DigitalOcean Droplet

In the last project [static-site-server](https://github.com/larsb-dev/devops-roadmap/tree/main/static-site-server] I've already setup an A record that points to my domain)

```bash
dig azurecloudlab.com

azurecloudlab.com.	5	IN	A	138.197.87.196
```

I've also set up a CNAME record for the host www that points to azurecloudlab.com.

Should the IP address of the A record change, the aliases won't break.

## DNS for GitHub Pages

- I had to add another CNAME record for my GitHub pages site to me DNS records
- I've chosen `octocat` which now points to `larsb-dev.github.io`
- This was an easy setup
- Adding Apex domain would require adding A records

octocat.azurecloudlab.com

- [Configuring a subdomain](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-a-subdomain)
