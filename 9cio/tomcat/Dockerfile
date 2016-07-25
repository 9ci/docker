FROM isuper/java-oracle

MAINTAINER Ken Roberts <kroberts@9ci.com>

# Tomcat snippet taken and slightly modified from https://hub.docker.com/r/apexits/ubuntu-oracle-jdk8-tomcat9/~/dockerfile/

ENV CATALINA_HOME /opt/tomcat
ENV WEBAPPS $CATALINA_HOME/webapps
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
	05AB33110949707C93A279E3D3EFE6B686867BA6 \
	47309207D818FFD8DCD3F83F1931D684307A10A5 \
	541FBE7D8F78B25E055DDEE13C370389288584E7 \
	61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
	79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
	9BA44C2621385CB966EBA586F72C284D731FABEE \
	A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
	DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
	F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.4
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& gpg --verify tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*
	
#Patching the tomcat to create a admin user.
RUN cp $CATALINA_HOME/conf/tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.org.xml
RUN sed 's?.*/tomcat-users>.*?<role rolename="manager-gui"/>\n <role rolename="admin-gui"/> \n <user username="admin" password="admin" roles="admin-gui, manager-gui"/> \n\n&?' $CATALINA_HOME/conf/tomcat-users.xml > $CATALINA_HOME/conf/tomcat-users.new.xml
RUN mv $CATALINA_HOME/conf/tomcat-users.new.xml $CATALINA_HOME/conf/tomcat-users.xml

RUN rm -rf \
 $WEBAPPS/examples \
 $WEBAPPS/manager \
 $WEBAPPS/docs \
 $WEBAPPS/host-manager

WORKDIR $CATALINA_HOME

EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
