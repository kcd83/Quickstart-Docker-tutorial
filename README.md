# Docker quick start tutorial

In this quick tutorial you will run simple Docker commands so you can get hands on with the fundamental concepts of containers. No prior knowledge is expected and even if you have already dabbled you should be able to skim through this in only a few minutes.

Docker provides very lightweight and portable virtual machines using a technology called "cgroups" instead of a traditional hypervisor. Many of the benefits stem from not fully virtualising the whole hardware stack like a traditional virtual machine (VM) and instead Docker uses cgroups (control groups) to isolate the container while sharing the same Linux kernel. However, we are most interested in demonstrating the typical workflow, which is similar to compiling software locally and shipping the binaries except with Docker we package the whole machine. To update a running container we replace it with a newer version of the image. This is known as immutable infrastructure and it is easier to appreciate once you have seen it in action.

## Prerequisites

Install Docker CE Desktop from https://www.docker.com/get-started and have a command line. If you are on Windows this will be PowerShell.

Docker for Windows requires HyperV and actually launches a Linux VM called Mobylinux for Linux containers. Ignore Windows containers, they are an advanced use case you don't need to know about. All your interactions with Docker are proxied to Mobylinux and Docker for Windows needs your current password to mount you local drives, more on that later.

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
