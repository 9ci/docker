FROM dordoka/tomcat

MAINTAINER Ken Roberts <kroberts@9ci.com>

RUN mkdir -p /var/9ci/rootLocation/conf/ && \
    mkdir -p /var/9ci/rootLocation/setup/ && \
    mkdir -p /var/9ci/rootLocation/scripts/ && \
    mkdir -p /opt/tomcat/webapps/ROOT/

RUN apt-get update && apt-get install -y vim-nox tmux

ADD 9ci-config.groovy /var/9ci/rootLocation/conf/
ADD rcm-config.groovy /var/9ci/rootLocation/conf/
ADD catalina.properties /opt/tomcat/conf/
ADD rcm.war /opt/tomcat/webapps/
ADD index.html /opt/tomcat/webapps/ROOT/

EXPOSE 8080
EXPOSE 8009
WORKDIR /opt/tomcat

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
