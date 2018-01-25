# Build the 9ci tomcat

The tomcat9ci Dockerfile uses the latest apache tomcat of the appropriate version (currently 8.5) and modifies it for 9ci use.

Look at the Dockerfile for specific documentation.

# Initial setup:

Copy the rootLocation from rcm/rootLocation for whatever version of rcm you intend to run. Put it in /var/9ci/rootLocation on your host, or whatever directory will map to it.

Run the following commands:

```
sudo mkdir -p /var/9ci
sudo chown $USER:$USER /var/9ci

mkdir -p /var/9ci/tomcat9ci_app/logs
mkdir -p /var/9ci/tomcat9ci_app/webapps
mkdir -p /var/9ci/wars/rcm

# This is an example. Get a war, copy it to /var/9ci/wars/rcm/
cp ~/workspace/9.9.x/rcm/target/rcm-9.9.x-2018-01-24--20-25-00.war /var/9ci/wars/rcm/

cd /var/9ci/wars/rcm/
ln -s rcm-9.9.x-2018-01-24--20-25-00.war current.war

cd /var/9ci/tomcat9ci_app/webapps
ln -s /var/9ci/wars/rcm/current.war rcm.war

# This is an example. Get a rootLocation from rcm (or from teamcity) and copy it over.
cp -rax ~/workspace/9.9.x/rcm/rootLocation /var/9ci/
```

You will want to modify the rootLocation/conf files to match your system.

# Development cycle

### Build an image for this project

From this directory:

```
docker build -t tomcat9ci .
```

### Run image in background in new container

```
docker run -d -p 8180:8080 -p 8280:8009 -v /var/9ci/tomcat9ci_app/webapps:/usr/local/tomcat/webapps -v /var/9ci/tomcat9ci_app/logs:/usr/local/tomcat/logs -v /var/9ci/rootLocation:/var/9ci/rootLocation -v /var/9ci/wars:/var/9ci/wars --name tomcat9ci_app -t tomcat9ci
```

The above command has the following features:

Parameter                                                    | Comments
=============================================================|======================
-d                                                           | run as a background process
-p 8180:8080                                                 | map the http docker image port (8080) to 8180 on the host for this container.
-p 8280:8009                                                 | The AJP port maps to 8280 on the host for this container.
-v /var/9ci/tomcat9ci\_app/webapps:/usr/local/tomcat/webapps | This container's webapps directory will be at /var/9ci/tomcat9ci\_app/webapps
-v /var/9ci/tomcat9ci\_app/logs:/usr/local/tomcat/logs       | This container's logs directory will be at /var/9ci/tomcat9ci\_app/logs directory on the host.
-v /var/9ci/rootLocation:/var/9ci/rootLocation               | This container's rootLocation will map to the same location on the host.
-v /var/9ci/wars:/var/9ci/wars                               | The wars directory maps to the same location on the host.
--name tomcat9ci\_app                                        | The name of this container is tomcat9ci\_app.
-t tomcat9ci                                                 | The image to build from is tomcat9ci made in the previous section.


# Useful commands

Command                                   | What it does
==========================================|=========================================
docker ps                                 | See the running containers
docker ps -a                              | See all containers, whether they're running or not.
docker images                             | See the docker images you have available.
docker start tomcat9ci_app                | Restart an existing, stopped container
docker exec -it tomcat9ci_app /bin/bash   | Get a command shell to browse the running container
docker stop tomcat9ci_app                 | Stop the running container
docker rm tomcat9ci_app                   | Permanently destroy the container
docker rmi tomcat9ci                      | Permanently destroy the image
docker pull tomcat:8.5                    | Update the tomcat:8.5 image with the latest updates from the docker hub.

# MSSQL

To create a new mssql container named 'mmsql' with bridged networking.

```
docker run --name duck -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=999Pl@z@dr1v3' -p 1433:1433 -d microsoft/mssql-server-linux:2017-latest
```


