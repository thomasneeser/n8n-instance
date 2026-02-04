# n8n-instance
Create your own Docker-based n8n-instance for free.

## Requirements

- A Linux server running Ubuntu - for tests I'm using the Google Cloud free tier
- Your own domain with ssl-certificate and the ability to configure the domains A record - I'm using the free subdomain service https://desec.io/

## Installation

### First step: Create your Ubuntu-VM-instance
- First, configure a VM instance of a linux server with ubuntu using Google Cloud Services:
  - create an new free tier VM-Instance:
    - e2-micro (2 vCPUs, 1 GB RAM),
    - Ubunutu 25.10 Manual pre-installed,
    - bootdrive standard with 30 GB,
    - network settings: activate HTTP- HTTPS- and Load-Balancer-system-diagnosis)
  - Here is an illustrated guide if you are having difficulty setting it up: https://aiagencyplus.com/self-host-n8n-free-google-cloud-docker-compose/

### Second step: Register a domain with an SSL certificate to access n8n
- Register a domain with an SSL certificate and configuration options for the A record
- For this project I'm using the free subdomain service https://desec.io/ by clicking "create account", option "register a new domain under deydn.io" and type in the URL, e.g. "my-n8n-server" for URL "https://my-n8n-server.deydn.io"
- After finishing registration login to your deydn.io-account, add a "A record" and type in the ip-address of the VM-machine you created in the first step, you can find die ip in your VM-instance description under "external ip address"
- Now save and ,ake sure, that your A record is updated on the DNS servers, before you proceed setup. You can find it out here: https://dnschecker.org/#A/

### Third and last step: Install your n8n-instance 
- Now go to your vm instance on google cloud services, open the SSH terminal and run:
```bash
cd /root
curl -L https://raw.githubusercontent.com/thomasneeser/n8n-instance/main/setup-n8n.sh | bash
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
