# Docker basics

## Commands to learn

- `docker image pull nginx`
- `docker image ls`
- `docker container run -p 9000:80 nginx`
- `docker container run -it -p 9000:80 nginx`
- `docker container run -it -p 9000:80 nginx bash`
- `docker container run -d -p 9000:80 nginx`
- `docker container exec -it quirky_elion bash`
- `docker exec -it $(docker container ls -q -f 'ancestor=nginx') bash`
- `docker container run -v ${pwd}/index.html:/usr/share/nginx/html/index.html -p 9000:80 nginx`

- `docker image build -t helloworld .`
- `docker container run -p 9000:80 helloworld`

- `docker exec -it $(docker container ls -q -f 'ancestor=nginx') bash -c 'echo Howdy >> /usr/share/nginx/html/index.html'`
