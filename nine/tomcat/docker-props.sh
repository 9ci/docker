sed 's/^\(common.loader=\)\("\${catalina.base}\/lib",\)/\1"\/var\/9ci\/rootLocation\/conf",\2/' /opt/tomcat/conf/catalina.properties > /tmp/catalina.properties

mv /tmp/catalina.properties /opt/tomcat/conf/catalina.properties

echo "CATALINA_OPTS='-Xmx2g'" > '/opt/tomcat/bin/setenv.sh'
