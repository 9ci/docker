# Docker setup for 9ci software

# Site initialization

This chapter has steps which should only take place if the system is being initially setup, or
possibly if something needs to be updated.

___All commands assume you have a terminal window changed to the docker/nine directory unless explicitly
stated otherwise.___

## Create a registry

```
docker-compose -f registry-compose.yml create
docker start registry9ci
```

## Create some images we need.

And store them in our registry.

### mysql9ci

```
docker build -t mysql9ci ./mysql9ci/
docker tag mysql9ci localhost:5000/mysql9ci
docker push localhost:5000/mysql9ci
```

### tomcat9ci

```
docker build -t tomcat9ci ./tomcat9ci/
docker tag tomcat9ci localhost:5000/tomcat9ci
docker push localhost:5000/tomcat9ci
```


## Install mysql

__See the [mysql9ci README.md](mysql9ci/README.md) file for critical information before installing this!__


```
docker-compose -f mysql-compose.yml create
docker start mysql9ci
```

## Build or restore the databases you need.

This is external to this document. If you had an existing mysql database on your host and didn't change
the build, then you probably have all the databases you had before already.

## Install the tomcats and apps

Use one of the following commands based on the type of install you're doing:

```
docker-compose -f customer-compose.yml create
docker-compose -f developer-compose.yml create
docker-compose -f teamcity-compose.yml create
```

and then:

```
sudo chown -R $USER:$USER ../../
```

## Get a rootLocation

You need a rootLocation to start with, and it needs to be consistent with the version of the
apps you will use in this environment.

Put it in __9ci__/rootLocation.

* The docker mysql host is __mysql9ci__. Replace all occurrences of `127.0.0.1` with `mysql9ci`.
* No matter where you put __9ci__ directory, it is `/var/9ci/rootLocation` within config files even if
you're on windows or teamcity or a dev box!

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
sudo tail -n 1000 -F rcm-info.log
```

# Paths

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
