Building an Application Server for your Home Lab 
================================================
(last update: 06JUN22)

This is a general rundown of how I build an Ubuntu image with the required IP addressing and various applications I used to run the various BIG-IP and other labs described in the partner lab guide, which is part of this repository, but the server is useful for all sorts of labs.

Ubuntu Build
------------
This build starts with a fresh import of the Ubuntu 18.04 or 20.04 image, 4 gig, 4cpus, 30gig HD

Basic Ubuntu Housekeeping
-------------------------
To prep for docker and just generally get everything up-to-date prior to building.

First you should always update your default password:

```
sudo password ubuntu
```

First lets make sure apt is up-to-date.
```
sudo apt update -y
sudo apt upgrade -y
```

If you want additional users, like a student user
```
adduser <username>
sudo usermod -aG sudo <username>
sudo usermod -aG root <username>
```
Networking
----------
In VM Workstation my NGLamp build used 4 interfaces, 3 interfaces to emulate the lab environments and 1 bridged interface to get the ball rolling.  The following files can be place into the netplan folder to build out the specified IP addressing.  You of course can feel free to do things differently.

For my build on VMWare Workstation:
- Interface 1 is the OOB management network (10.1.1.0/24) defined by 01-network-manager-all.yaml
- Interface 2 is the outside/client-side network (10.1.10.0/24) defined by 02-network-manager-all.yaml
- Interface 3 is the applications/server-side network (10.1.20.0/24) by 03-network-manager-all.yaml
- Interface 4 is a bridged network using DHCP to get my initial network connectivity defined by 04-network-manager-all.yaml

You don't need the entire **git** repository, but it does make the build instructions easier and is used again later.  Here we install git, clone the repository, copy over the network manager configuration files and then apply them.
```
cd /home/ubuntu
sudo apt install git -y
git clone https://github.com/leifbr/partnerlabs.git /home/ubuntu/git/partnerlabs/
sudo cp /home/ubuntu/git/partnerlabs/homelab/*network-manager*.yaml /etc/netplan/
sudo netplan apply
```

Installing docker
----------------
All the applications are docker containers because it just makes life easier. Install **docker** and set it up to start on boot and get **docker** started.
```
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
```

Applications
============
There are a number of applications I use, or find valuable, for my own lab work and for training.  I may add more from time to time.

Start up f5-demo-app containers
-------------------------------
This is a basic web application server written by Eric Chen, an F5 solution architect and can be used for basic ADC labs, for load balancing labs, irules and more.  
```
docker pull chen23/f5-demo-app
sudo docker run -itd --restart unless-stopped --name f5demo1 -p 10.1.20.11:80:80 chen23/f5-demo-php
sudo docker run -itd --restart unless-stopped --name f5demo2 -p 10.1.20.12:80:80 chen23/f5-demo-php
sudo docker run -itd --restart unless-stopped --name f5demo3 -p 10.1.20.13:80:80 chen23/f5-demo-php
sudo docker run -itd --restart unless-stopped --name f5demo4 -p 10.1.20.14:80:80 chen23/f5-demo-php
```
Hackazon
--------
https://owasp.org/www-project-vulnerable-web-applications-directory/ 

This is a vulnerable web application created by the OWASP project that I have used for years for BIG-IP Advance WAF labs and I keep it around because I am to lazy to update all my lab guides.   The BIG-IP Advanced WAF Fundamentals training uses this application. 
```
sudo docker run -itd  --restart unless-stopped --name hack20 -p 10.1.20.20:80:80 mutzel/all-in-one-hackazon:postinstall ./start.sh 
```

Juice Shop
----------
https://owasp.org/www-project-juice-shop/ 

This app is also from the OWASP project, but is much more like a modern app than Hackazon.   The application runs off the 3000 port in the container. 
```
sudo docker run -itd  --restart unless-stopped --name juice30 -p 10.1.20.30:80:3000 bkimminich/juice-shop
```

Arcadia Financial 
-----------------
API application, partially running behind NGINX OSS, that was put together by Matthieu Dierick, another F5 solution architect.  I have high hopes for labs around this application.  The main thing I use is for is F5 Distributed Cloud Web Application and API Protection, that is a long type, aka F5 XC WAAP, so I can show off the API mapping and swagger capabilities of our XC ML/AI solution.   We need a NGINX default.conf file for the Arcadia front-end API behind NGINX which we will copy over from **partnerlabs** repository when we start up the front-end container.
```
sudo docker network create internal
sudo docker run -dit --restart unless-stopped -h mainapp --name=mainapp --net=internal registry.gitlab.com/arcadia-application/main-app/mainapp:latest
sudo docker run -dit --restart unless-stopped -h backend --name=backend --net=internal registry.gitlab.com/arcadia-application/back-end/backend:latest
sudo docker run -dit --restart unless-stopped -h app2 --name=app2 --net=internal registry.gitlab.com/arcadia-application/app2/app2:latest
sudo docker run -dit --restart unless-stopped -h app3 --name=app3 --net=internal registry.gitlab.com/arcadia-application/app3/app3:latest

sudo docker run -dit --restart unless-stopped -h nginx --name=nginxarcadia --net=internal -p 10.1.20.50:80:80 -v /home/ubuntu/git/partnerlabs/homelab/arcadia-nginx-default.conf:/etc/nginx/conf.d/default.conf registry.gitlab.com/arcadia-application/nginx/nginxoss:latest
```
Well, that’s it for now.  You should be ready to go.  Hopefully you will find this of some use.

