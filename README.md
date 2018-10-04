# Docker quick start tutorial

In this quick tutorial you will run simple Docker commands so you can get hands on with the fundamental concepts of containers. No prior knowledge is expected and even if you have already dabbled you should be able to skim through this in only a few minutes.

Docker provides very lightweight and portable virtual machines using a technology called "cgroups" instead of a traditional hypervisor. Many of the benefits stem from not fully virtualising the whole hardware stack like a traditional virtual machine (VM) and instead Docker uses cgroups (control groups) to isolate the container while sharing the same Linux kernel. However, we are most interested in demonstrating the typical workflow, which is similar to compiling software locally and shipping the binaries except with Docker we package the whole machine. To update a running container we replace it with a newer version of the image. This is known as immutable infrastructure and it is easier to appreciate once you have seen it in action.

## Prerequisites

Install Docker CE Desktop from https://www.docker.com/get-started and have a command line. If you are on Windows this will be PowerShell.

Docker for Windows requires HyperV and actually launches a Linux VM called Mobylinux for Linux containers. Ignore Windows containers, they are an advanced use case you don't need to know about. All your interactions with Docker are proxied to Mobylinux and Docker for Windows needs your current password to mount you local drives, more on that later.

Enough words, let's run something.

## Run a container from an image

In this section we learn how to run and existing container, when finished you should understand what this does: `docker container run --rm -d --name myweb -p 9000:80 nginx`

Get the popular official image of the webserver nginx ("engine X").

    docker image pull nginx

List all images.

    docker image list

Run a container instance of nginx and map a local port to port 80 (`--publish`) then open it in your browser: http://localhost:9000

    docker container run -p 9000:80 nginx

You might be prompted allow this through your local firewall, allow it. You should see access logs for `"GET / HTTP/1.1" 200` or the Not Modified status `304` when you refresh you browser.

Press `Ctrl+C` to detach. The container is still running in the background and you can see it with:

    docker container list

Note the quirky auto-generated name and id, either can be used to identify the container (tip: only enough of the id to be unique is required).

Using an identifier to show and follow the output, like before we detached.

    docker container logs --tail 1 --follow determined_darwin

Press `Ctrl+C` to detach. With the same (or different) identifier stop the container.

    docker container kill 96

Great, your browser should not show an error connecting. However the container still exists when you also list stopped containers (`--all`).

    docker container list
    docker container list -a

Now remove it.

    docker container rm determined_darwin

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
