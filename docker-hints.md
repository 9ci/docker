# Things to know about docker

Docker runs as root. Any directories or files created by a docker container on your host are owned by root
and likely not readable by a non-root user.

You can change ownership after they are created though.

Any files you created on the host for use by docker containers keep their original ownership.

# Useful commands

>Note: The items in the left column are on one line. Github is wrapping when it shouldn't.

Command                                     | What it does
--------------------------------------------|-----------------------------------------
`docker ps`                                 | See the running containers
`docker ps -a`                              | See all containers, whether they're running or not.
`docker images`                             | See the docker images you have available.
`docker start tomcat9ci_app`                | Restart an existing, stopped container
`docker exec -it tomcat9ci_app /bin/bash`   | Get a command shell to browse the running container
`docker stop tomcat9ci_app`                 | Stop the running container
`docker rm tomcat9ci_app`                   | Permanently destroy the container
`docker rmi tomcat9ci`                      | Permanently destroy the image
`docker pull tomcat:8.5`                    | Update the tomcat:8.5 image with the latest updates from the docker hub.

# MSSQL

To create a new mssql container named 'mmsql' with bridged networking.

```
docker run --name duck -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=999Pl@z@dr1v3' -p 1433:1433 -d microsoft/mssql-server-linux:2017-latest
```


