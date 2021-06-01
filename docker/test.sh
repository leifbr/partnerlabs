sudo docker stop partnerlabs
sudo docker rm partnerlabs
sudo docker run -it --rm -d -p 80:80 --name partnerlabs partnerlabs
