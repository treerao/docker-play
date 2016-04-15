# Docker Play

This guide provides a quick start on using a local host for
docker-based development. The local setup should work across
desktop platforms:

 - Mac OS X
 - Windows
 - Linux - including EC2 Linux instances

TBD -- PaaS-based Deployment Clusters

 - Amazon Elastic Container Service (ECS)
 - Google Container Engine


## Local Setup

Docker's install guides are quite easy to follow and provide a
fine overview of the important concepts. The Docker Toolkit
Installers for Mac and Windows are quite straightforward.  So you
can just start on the [Mac OS X][macinstall] or the
[Windows][windowsinstall] install pages, and hunt for your
preferred linux from there if that's what you need instead.


[macinstall]: https://docs.docker.com/engine/installation/mac/
[windowsinstall]: https://docs.docker.com/engine/installation/windows/

Once you've installed the Docker Toolkit, you'll have everything
you'll need and also the Kitematics desktop application which
makes it easy to browse and manage images and containers.

## Using a VM as a Docker Host

Docker Machine is the tool for managing virtual machines that can
act as Docker Hosts. You can have as many as you want.

    docker-machine create scratch --driver "virtualbox"
    docker-machine ls
    docker-machine inspect scratch

Set up environment variables to point at "scratch" virtual
machine, so docker commands will use that VM.

    eval $(docker-machine env scratch)

## Running Official Images

Set up environment variable for convenience:

    git clone git@github.com:treerao/docker-play
    cd docker-play
    export PLAYHOME=$PWD

Start up various official DB images, e.g.

    docker run -d redis
    docker run -d -v $PLAYHOME/initdb:/docker-entrypoint-initdb.d postgres

Run a simple python webserver.

    docker run -d -p 80:8000 -v $PLAYHOME/eg:/home/eg \
        --workdir /home/eg --entrypoint ./start.sh \
        centos

Try it out, using docker-machine inspect to get the IP Address
and using open command on Mac OSX.

    export DOCKER_HOST_IP=`docker-machine inspect scratch --format '{{ .Driver.IPAddress }}'`
    open http://$DOCKER_HOST_IP

Take a look at what you have running, and inspect the default
network and one of the containers:

    docker ps
    docker network inspect bridge
    docker inspect `docker ps -a -q | head -n 1`

Stop/Removing all those containers:

    docker stop `docker ps -a -q`
    docker rm `docker ps -a -q`


## Using Docker Compose

You can bring up a set of connected containers, e.g. a web app
along with some datbase containers. (In the example, there's no
actual use of the redis or postgre containers yet.)

    docker-compose --file eg/docker-compose.yml up -d
    open http://$DOCKER_HOST_IP

You can also control the group i.e. restart, stop, rm

    docker-compose --file eg/docker-compose.yml restart
    docker-compose --file eg/docker-compose.yml stop
    docker-compose --file eg/docker-compose.yml rm
