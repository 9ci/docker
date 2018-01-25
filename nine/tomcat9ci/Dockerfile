FROM tomcat:8.5

MAINTAINER Ken Roberts <kroberts@9ci.com>

# Add a system group for tomcat files.
RUN addgroup --system tomcat

# Add a system user for tomcat to run as.
RUN adduser --system --group tomcat

# Add our "hot" configuration directory to the tomcat classpath.
RUN sed -i 's/\(common.loader=\)/\1"\/var\/9ci\/rootLocation\/conf",/' /usr/local/tomcat/conf/catalina.properties

# Alter the 8080 (http) port to use NIO protocol.
RUN sed -i 's/\(<Connector port="8080" \)protocol="HTTP\/1.1"/\1\n\
               protocol="org.apache.coyote.http11.Http11NioProtocol"\n\
               maxThreads="1000"/' /usr/local/tomcat/conf/server.xml

# Alter the 8009 (AJP) port to use NIO protocol.
RUN sed -i 's/protocol="AJP\/1.3"/\n\
               connectionTimeout="20000"\n\
               maxThreads="1000"\n\
               protocol="org.apache.coyote.ajp.AjpNioProtocol"\n\
              /' /usr/local/tomcat/conf/server.xml

# Specify which ports can be exposed by the container.
EXPOSE 8080
EXPOSE 8009
