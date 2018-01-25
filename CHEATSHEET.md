# Build the 9ci tomcat


### Build an image for this project

```
cd nine/tomcat9ci
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

### Restart an existing, stopped container

```
docker start tomcat9ci_app
```

### Get a command shell to browse the running container

```
docker exec -it tomcat9ci_app /bin/bash
```

### Stop the container

```
docker stop tomcat9ci_app
```

### Destroy the container

```
docker rm tomcat9ci_app
```

### Destroy the image

```
docker rmi tomcat9ci
```

# Updates

```
# update the tomcat image after it has been loaded.
docker pull tomcat:8.5
```

# MSSQL

To create a new mssql container named 'mmsql' with bridged networking.

```
docker run --name duck -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=999Pl@z@dr1v3' -p 1433:1433 -d microsoft/mssql-server-linux:2017-latest
```


