docker stop jupyter
docker rm jupyter
APP_PASSWORD=rm\!t1234 docker run -d --restart=always --name jupyter --user=jupyter \
              --add-host=host.docker.internal:host-gateway \
              -e GIT_USER="Quan To" -e GIT_EMAIL="btquanto@gmail.com" \
              -v jupyter:/home/jupyter/workspace -p 2700:8888 btquanto/jupyterlab:latest
