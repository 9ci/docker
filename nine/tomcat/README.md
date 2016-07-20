# nine/tomcat

# build

build.sh is a wrapper around the build process.  It pulls the latest rcm.war from the ftp site, assuming you have an account.

sudo docker build -t nine/tomcat:{version}

# run

sudo docker run -d --net="host" -v /opt/tomcat/webapps:/opt/tomcat/webapps nine/tomcat:v14

Note that :v14 is the revision number you want to run.  This should be the latest image.

# command prompt

If your image is running and you want to connect to the container with a shell prompt then do this:

```sudo docker ps```

Collect the container ID from the output and paste in to this:

```sudo docker exec -it {container id} bash```

