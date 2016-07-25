FROM 9cio/tomcat

MAINTAINER Ken Roberts <kroberts@9ci.com>

# Add stuff that Ken likes.
RUN apt-get update && apt-get upgrade
RUN apt-get update && apt-get install -y vim-nox tmux less
RUN apt-get install -y mysql-client


ADD docker-props.sh /tmp/

RUN chmod 755 /tmp/docker-props.sh

RUN /tmp/docker-props.sh


EXPOSE 8080
EXPOSE 8009
WORKDIR /opt/tomcat

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
