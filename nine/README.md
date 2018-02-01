# Docker setup for 9ci software

This project aims to be one of:

1. A 9ci production app server pair at a customer site.
2. A developer environment.
3. One of many similar arrangements for teamcity.

# Prerequsites

1. A 64-bit system with adequate RAM and disk space.
2. Docker installed from https://www.docker.io
3. An understanding of performance issues for your platform with docker.
4. Disk space plan
5. Possibly an external database server.

# Conventions

## Directory locations

9ci uses a single folder as the root of all our files on a customer's application server. This
location is referred to as the __9ci__ directory. All locations we refer to start in the 9ci
directory unless specifically stated otherwise.

Docker and database services store their files somewhere else. It's strongly advised that you
find out where they are stored and ensure that there is proper space on the device.

### Host operating system specific differences

On Windows our __9ci__ directory should be `D:\9ci`.

On UNIX and Linux our __9ci__ directory should be `/var/9ci`.

Mac OS X is a UNIX, so it falls into the same category as Linux and UNIX.

### Paths internal to the docker containers

The docker image is Linux. Locations from within the docker image are UNIX filenames regardless
of the host operating system.

* `/var/9ci/rootLocation` is the tomcat-accessible configuration and file storage.
* `/var/9ci/wars` is the storage space for wars, to provide an ability to revert to a previous
  image without diffuculty. May not be used outside of production.

### Paths viewed from the host.

#### Production/customer test systems

* `9ci/docker` is the location of the docker setup containing the file you're reading.
* `9ci/rootLocation` is the tomcat-accessible configuration and file storage.
* `9ci/tomcat9ci_app` is the tomcat logs and webapps for __rcm__ and user-accessible apps
* `9ci/tomcat9ci_api` is the tomcat logs and webapps for the api and background apps.
* `9ci/wars` is the root of the war file storage.
	* `9ci/wars/rcm` will contain rcm wars WITH version number and date of creation.

#### Development systems

* Developers can choose the location. They should have a __9ci__ directory which contains this
  docker project.

#### Teamcity

Teamcity is a special case requiring tomcats for many different branches to work
simultaneously. It is on a Linux box so I'm using UNIX paths.

* `/var/9ci` contains everything.
* `/var/9ci/{gitBranch}` is the __9ci__ directory for each branch.
* `/var/9ci/{gitBranch}/docker` contains this docker project.
* Each docker project will need host-side ports modified appropriately for the branch.

# Site initialization

This chapter has steps which should only take place if the system is being initially setup, or
possibly if something needs to be updated.

## Create a registry and mysql database.

```
cd __9ci__/docker/nine
docker-compose -f base-compose.yml create
docker start registry
docker start mysqldb
```

## Build the tomcat9ci image and push it to your repository.

```
docker build -t tomcat9ci ./tomcat9ci/Dockerfile
docker tag tomcat9ci localhost:5000/tomcat9ci
docker push localhost:5000/tomcat9ci
```

## Build or restore the databases you need.

This is external to this document.

## Install the tomcats and apps

```
docker-compose create
```

## Get a rootLocation

You need a rootLocation to start with, and it needs to be consistent with the version of the
apps you will use in this environment.

Put it in __9ci__/rootLocation.

# App installation and upgrade.

## Get an application.

Apps are transferred to the system at __9ci__/wars/{appName}. They are stored with the version
numbers and dates. This enables easy reverts in case of a bad app, and a history of what has
been installed.

## Stop the appropriate app server

```
docker stop tomcat9ci_app
```

or


```
docker stop tomcat9ci_api
```

## Install the application(s)

```
cp __9ci__/wars/rcm/rcm-10.0.x-2018-01-31--08-05-29.war __9ci__/tomcat9ci_app/webapps/rcm.war
```

## Zap the logs

```
sudo tar -czf __9ci__/logzips/logs-`date +%Y$1%m$1%d-%H$2%M$2%S`.tgz __9ci__/tomcat9ci_app/logs
sudo rm -f __9ci__/tomcat9ci_app/logs/*
```

## Start the app server

```
docker start tomcat9ci_app
```

or

```
docker start tomcat9ci_api
```

## Watch the logs

```
cd tomcat9ci_app/logs
tail -n 1000 -F rcm-info.log
```