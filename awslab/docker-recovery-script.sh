# Docker recovery script
#!/bin/bash
echo install docker
sudo apt-get update -y
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
echo Start up containerize web services
sudo docker run -itd --restart unless-stopped --name partnerlabs -p 10.1.20.100:80:80 leifbr/partnerlabs
sudo docker run -itd --restart unless-stopped --name f5demo1 -p 10.1.20.11:80:80 chen23/f5-demo-php
sudo docker run -itd --restart unless-stopped --name f5demo2 -p 10.1.20.12:80:80 chen23/f5-demo-php
sudo docker run -itd --restart unless-stopped --name f5demo3 -p 10.1.20.13:80:80 chen23/f5-demo-php
sudo docker run -itd --restart unless-stopped --name f5demo4 -p 10.1.20.14:80:80 chen23/f5-demo-php
sudo docker run -itd --restart unless-stopped --name hack20 -p 10.1.20.20:80:80 mutzel/all-in-one-hackazon:postinstall ./start.sh > start.log
sudo docker run -itd --restart unless-stopped --name juice30 -p 10.1.20.20:3000:3000 bkimminich/juice-shop