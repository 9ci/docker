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

___Alert: base-compose.yml uses the /var/lib/mysql directory on the host. Make sure your host
copy of mysql is not enabled before you run this!___

See "Mysql installation notes" for more information.

```
cd __9ci__/docker/nine
docker-compose -f base-compose.yml create
docker start registry
docker start mysqldb
```

### Mysql installation notes

If you're running Linux as a host OS, then google __mysql barrier=0__. Mysql when left to its
own devices is unbearably slow.

If you're using a dev box, you may want to create a separate filesystem and put it in
`/etc/fstab` like this:

```
/dev/mapper/hddvg1-mysql                  /var/lib/mysql   ext4    defaults,barrier=0 0 2
```

Note that this creates an unsafe condition which can corrupt data. __Don't do this on a
production system!__

### Mysql access notes:

* The docker mysql is running in a vm, which is NOT LOCALHOST TO YOU!
* The mysql command-line client handles localhost in a special way.
* `mysql -u root -p` __will not work!__
* Use `mysql -h mysqldb -u root -p` instead.
* In order for this to work, you need to edit your static hosts file at `/etc/hosts`:

```
127.0.0.1    localhost mysqldb
```

The above edit (appending 'mysqldb' to the localhost entry in /etc/hosts) will allow you to
use the above command to access mysql in the docker container.

The issue is that mysql, when you connect to localhost or 127.0.0.1, will assume that the
server is running in the "current" host operating system. It tries to find a process ID and
communicate without using networking. It won't work because the file containing the process
ID is on the docker container, not the host OS, and the process is running in docker, not the
host OS.

By making the static hosts entry, you trick mysql into connecting as though it were a foreign
host, which is more correct than the assumption it's running on the host OS.

## Build the tomcat9ci image and push it to your repository.

```
docker build -t tomcat9ci ./tomcat9ci/Dockerfile
docker tag tomcat9ci localhost:5000/tomcat9ci
docker push localhost:5000/tomcat9ci
```

## Build or restore the databases you need.

This is external to this document.

## Install the tomcats and apps

One of the following commands based on the type of install you're doing:
```
docker-compose -f customer-compose.yml create
docker-compose -f developer-compose.yml create
docker-compose -f teamcity-compose.yml create
```

and then:

```
sudo chown -R $USER:$USER ../..
```

## Get a rootLocation

You need a rootLocation to start with, and it needs to be consistent with the version of the
apps you will use in this environment.

Put it in __9ci__/rootLocation.

* The docker mysql host is __mysqldb__. Replace all occurrences of `127.0.0.1` with `mysqldb`.
* No matter where you put __9ci__ directory, it is `/var/9ci/rootLocation` even if you're on
windows or teamcity or a dev box!

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