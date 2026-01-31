# n8n-instance
Create your own Docker-based n8n-instance.

## Requirements

- A Linux server running Ubuntu - I'm using the Google Cloud free tier
- Administrator rights on the server
- Your own domain with ssl-certificate and the ability to configure the domains A record - I'm using the free subdomain service https://desec.io/

## Installation

- First, configure a VM instance of a linux server with ubuntu using Google Cloud Services. Here is how to set it up: https://aiagencyplus.com/self-host-n8n-free-google-cloud-docker-compose/
- Create your domain for your n8n-server and add your IP address to the A record of your domain service - I'm using a free subdomain service https://desec.io/
- Make sure, that your A record is updated on the DNS servers, before you proceed setup. You can find it out here: https://dnschecker.org/#A/
- Now go to your vm instance on google cloud services, open the SSH terminal and run:
```bash
cd /root
curl -L https://raw.githubusercontent.com/thomasneeser/n8n-instance/main/setup-n8n.sh -o setup-n8n.sh
chmod +x setup-n8n.sh
./setup-n8n.sh
```
- Follow the on-screen instrucitons.
- After finishing the process open your domain and enjoy your n8n-instance! :-)

## Troubleshooting

- If your n8n-URL loads with an SSL error, run this commands, wait about 5 minutes and reload URL:
```bash
sudo docker compose down
sudo rm -rf ./letsencrypt/acme.json
sudo docker compose up -d --force-recreate
```
