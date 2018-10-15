# Docker quick start tutorial

In this quick tutorial you will run simple Docker commands so you can get hands on with the fundamental concepts of containers. No prior knowledge is expected and even if you have already dabbled you should be able to skim through this in only a few minutes.

Docker provides very lightweight and portable virtual machines using a technology called "cgroups" instead of a traditional hypervisor. Many of the benefits stem from not fully virtualising the whole hardware stack like a traditional virtual machine (VM) and instead Docker uses cgroups (control groups) to isolate the container while sharing the same Linux kernel. However, we are most interested in demonstrating the typical workflow, which is similar to compiling software locally and shipping the binaries except with Docker we package the whole machine. To update a running container we replace it with a newer version of the image. This is known as immutable infrastructure and it is easier to appreciate once you have seen it in action.

## Prerequisites

Install Docker CE Desktop from https://www.docker.com/get-started and have a command line. If you are on Windows this will be PowerShell.

Docker for Windows requires HyperV and actually launches a Linux VM called Mobylinux for Linux containers. Ignore Windows containers, they are an advanced use case you don't need to know about. All your interactions with Docker are proxied to Mobylinux and Docker for Windows needs your current password to mount you local drives, more on that later.

Enough words, let's run something.

## Run a container from an image

In this section we learn how to run an existing container, when finished you should understand what the following command does: `docker container run --rm -d --name myweb -p 9000:80 nginx`

Get the popular webserver nginx ("engine X"). This is the latest official image from: https://hub.docker.com/_/nginx/

    docker image pull nginx

List all images.

    docker image list

Run a container instance of nginx and map a local port to port 80 (`-p` is `--publish`) then open it in your browser: http://localhost:9000

    docker container run -p 9000:80 nginx

You might be prompted allow this through your local firewall, allow it. You should see access logs for `"GET / HTTP/1.1" 200` or the Not Modified status `304` when you refresh you browser.

Press `Ctrl+C` to detach. The container is still running in the background and you can see it with:

    docker container list

Note the quirky auto-generated name and id, either can be used to identify the container (tip: only enough of the id to be unique is required).

Using an identifier to show and follow the output, like before we detached.

    docker container logs --tail 1 --follow determined_darwin

Press `Ctrl+C` to detach. With the same (or different) identifier stop the container.

    docker container kill 96

Great, your browser should now show an error connecting when you refresh. However the container still exists when you also list stopped containers (`-a` is `--all`).

    docker container list
    docker container list -a

Now remove it.

    docker container rm determined_darwin

That was easy, but let's check help on the run command for how to reduce the number of steps.

    docker container run --help

```
Usage:  docker container run [OPTIONS] IMAGE [COMMAND] [ARG...]

Run a command in a new container

Options:
...
  -d, --detach                         Run container in background and
      --name string                    Assign a name to the container
  -p, --publish list                   Publish a container's port(s) to
      --rm                             Automatically remove the container
...
```

The following will start a container in the background with a known name and it deletes itself on termination.

    docker container run --rm -d --name myweb -p 9000:80 nginx

When we are done, use our name to stop and remove it.

    docker container stop myweb

## Interactive "login" into a container

To debug or otherwise interact with a VM you would probably ssh into it, and similarly with a container it is useful to understand how to run an interactive shell. Specially this section will show you how to use `-it` with `exec` or `run` for bash in either an existing or new container.

If it is not already running, start an nginx container.

    docker container run --rm -d --name myweb -p 9000:80 nginx

Execute the unix name utility inside the container, arguments can be sent too.

    docker container exec myweb uname
    docker container exec myweb uname --all

Execute a command that reads standard input (`-i` is `--interactive`) and counts words with "o" characters.

    echo hello world | docker container exec -i myweb grep -c o

Note if this does not return "2" it could be your console emulator, you can try another but it is not as important as the next combination.

Execute an interactive terminal (`-t` is `--tty`). Type `exit` to end the bash shell.

    docker container exec -i -t myweb bash
    ls -la
    cat /usr/share/nginx/html/index.html
    exit

Run a bash shell in a new container (`-it` is `--interactive` and `--tty`).

    docker container run --rm -it alpine sh
    ls -la
    exit

This will pull the alpine image if you don't already have it. This is a minimal image commonly used because of its small size (try listing images again). It does not contain bash which is why we use the simpler bourne shell (`sh`).

## Building and modifying a container

Editing file and packages inside seems like a good idea, try appending a message to the default webpage of nginx to be visible at: http://localhost:9000

    docker container exec -i -t myweb bash
    cd /usr/share/nginx/html
    echo 'Hello' >> index.html
    exit

Or instead run do it in one line.

    docker container exec myweb bash -c 'echo Howdy >> /usr/share/nginx/html/index.html'

This change will show up in the browser, however it is normal practice to replace containers so spin up our container again.

    docker container kill myweb
    docker container run --rm -d --name myweb -p 9000:80 nginx

Now we have a new instance and our modification is lost, check your browser.

To build our own version we will add layers to nginx, create a `Dockerfile` containing:

```Dockerfile
FROM nginx

RUN echo "<p><i>Built at $(date)</i></p>" >> /usr/share/nginx/html/index.html
```

Build it with a custom name (`-t` is `--tag`, despite being "name and optionally a tag"). The trailing `.` is the path to the build context directory containing our file.

    docker image build -t helloworld .

List the images and you will see our image with the default tag of `latest`.

    docker image list helloworld

Note the full naming scheme is `<[registry address]>/<[user or project]>/<image name>[:<tag>]` and repository is fully qualified image name excluding the tag.

    docker container stop myweb
    docker container run --rm -d --name myweb -p 9000:80 helloworld

In the browser you will see our build date time appended to the bottom.

To add our own web page create an `index.html` with HTML such as the following:

```html
<!DOCTYPE html>
<html>
<title>My Web</title>
<body>
    <h1>Hello World</h1>
</body>
</html>
```

Place that file beside our `Dockerfile` then copy it over the top of the default using the `COPY` line below:

```Dockerfile
FROM nginx

COPY index.html /usr/share/nginx/html/index.html

RUN echo "<p><i>Built at $(date)</i></p>" >> /usr/share/nginx/html/index.html
```

Build your image again, this time with a tag. List the your new image to see both all versions of your image.

    docker image build -t helloworld:2 .
    docker image list helloworld

Run it and in the browser you will now see your own webpage.

    docker container stop myweb
    docker container run --rm -d --name myweb -p 9000:80 helloworld:2


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
