# n8n-instance
Create your own docker-based n8n-instance.

## Requirements

- A Linux server running Ubuntu - I'm using the google cloud free tier
- Administrator rights on the server
- a own domain with ssl-certificate and the ability to configure the domains a-record - I'm using a free subdomain service https://desec.io/

## Installation

- At first we configure a vm instance of a linux server with ubuntu by google cloud service, here is how to configure this: https://aiagencyplus.com/self-host-n8n-free-google-cloud-docker-compose/
- create your domain for your n8n-server and type your ip-adress into the a-record of your domain service - I'm using a free subdomain service https://desec.io/
- now go to your vm instance on google cloud services, open SSL-Panel and type:
```bash
cd /root
curl -L https://raw.githubusercontent.com/thomasneeser/n8n-instance/main/setup-n8n.sh -o setup-n8n.sh
chmod +x setup-n8n.sh
./setup-n8n.sh
```
- follow instructions on the screen
- after finishing process open your domain and enjoy your n8n-instance! :-)

