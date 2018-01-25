FROM tomcat:8.5

MAINTAINER Ken Roberts <kroberts@9ci.com>

#RUN apt-get update 
#RUN apt-get upgrade -y
RUN addgroup --system tomcat
RUN adduser --system --group tomcat
RUN sed -i 's/\(common.loader=\)/\1"\/var\/9ci\/rootLocation\/conf",/' /usr/local/tomcat/conf/catalina.properties
RUN sed -i 's/\(<Connector port="8080" \)protocol="HTTP\/1.1"/\1\n\
               protocol="org.apache.coyote.http11.Http11NioProtocol"\n\
               maxThreads="1000"/' /usr/local/tomcat/conf/server.xml
RUN sed -i 's/protocol="AJP\/1.3"/\n\
               connectionTimeout="20000"\n\
               maxThreads="1000"\n\
               protocol="org.apache.coyote.ajp.AjpNioProtocol"\n\
              /' /usr/local/tomcat/conf/server.xml

EXPOSE 8005
EXPOSE 8080
EXPOSE 8009
