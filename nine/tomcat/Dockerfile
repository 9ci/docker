FROM dordoka/tomcat

MAINTAINER Ken Roberts <ken@9ci.com>

#RUN WARNAME=`ssh teamcity.9ci.com 'ls -t ftp/wars/rcm/989/rcm-9.9.x* | head -n 1'` && \
#echo $WARNAME && \
#scp teamcity.9ci.com:$WARNAME /opt/tomcat/webapps/rcm.war

RUN mkdir -p /var/9ci/rootLocation/conf/
RUN mkdir -p /var/9ci/rootLocation/setup/
RUN mkdir -p /var/9ci/rootLocation/scripts/
RUN mkdir -p /opt/tomcat/webapps/ROOT/

ADD 9ci-config.groovy /var/9ci/rootLocation/conf/
ADD rcm-config.groovy /var/9ci/rootLocation/conf/
ADD catalina.properties /opt/tomcat/conf/
ADD rcm.war /opt/tomcat/webapps/
ADD index.html /opt/tomcat/webapps/ROOT/

EXPOSE 8080
EXPOSE 8009
VOLUME "/opt/tomcat/webapps"
WORKDIR /opt/tomcat

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
