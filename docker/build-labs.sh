tar cvzf partnerlabs.tar.gz ~/git/partnerlabs/docs/_build/html/
sudo docker build -t partnerlabs .
sudo docker stop partnerlabs
sudo docker run -it --rm -d -p 80:80 --name partnerlabs partnerlabs