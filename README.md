# Purpose

This project sets up a set of docker containers for multiple purposes:

1. Production tomcat app servers
2. Development app server
3. Teamcity app servers.

Each uses different files but they all have a common flow.

# Why the extra directory?

The reason for the 'nine' directory is that docker-compose automatically sets up a network for
docker containers based on the containing directory of the project.

Rather than have it be called 'docker_default' I chose to have it be called 'nine_default'.

# Prerequisites

* A 64-bit system with adequate RAM and disk space.
* Docker installed from https://www.docker.io or available from your distro repository
* An understanding of performance issues for your platform with docker.
* Disk space plan
* Production systems will need an external database server.

# Directory structure for this project.

This chapter describes where things can be found on the host system.

## The docker directory.

The directory containing the docker repository is the __docker__ directory.

A developer may have multiple __docker__ directories, but teamcity and customer sites will
only have one.

The __docker__ directory (and this project) contains only things from github. No site-specific
configuration, no apps, no mapped volumes. It keeps everything clear and documents the site.

## The 9ci directory

9ci application server software goes into `/var/9ci` for UNIX and `D:\9ci` on Windows. For
customer and common sites (9ci internal servers) we will stick with that convention. This
directory is called the __9ci__ directory within this document.

On the application server, everything we install related to the application goes into the
__9ci__ directory.

However with this project you can put the __9ci__ directory wherever you want. You need to have
the __docker__ directory directly inside of your __9ci__ directory. So on UNIX the __docker__
directory is `/var/9ci/docker` and on Windows it's `D:\9ci\docker`.

Wherever you put the __docker__ directory, the parent of this directory becomes your __9ci__
directory.

# Directory structure inside the images

The `nine` directory contains folders to build images we use. The documentation there
has internal image locations and information about what you need to know.