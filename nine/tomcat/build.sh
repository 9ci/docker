if [ $# != 1 ]; then
    echo "usage: ./build.sh {version}"
    echo "example: ./build.sh v11"
    exit 1
fi
WARNAME=`ssh teamcity.9ci.com 'ls -t ftp/wars/rcm/989/rcm-9.9.x* | head -n 1'` && \
echo $WARNAME && \
scp teamcity.9ci.com:$WARNAME rcm.war
sudo docker build -t nine/tomcat:$1 .
