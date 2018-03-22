# Linode2 box -- ln02.9ci.com

This document describes everything done to ln02.9ci.com.

# Tasks

## Get rancher setup on linode

https://rancher.com/docs/rancher/v1.6/en/quick-start-guide/ has the initial info

see https://linode.com/docs/applications/containers/how-to-deploy-apps-with-rancher/ It might be out of date as their script might not be needed.


## Create a latest teamcity in it

## Show us that it works


# Currently on the system

1. apache2 for \*.greenbill.com certificate and front-end for all the tomcats.
2. mysql on docker - persistent from ../nine/mysql-compose.yml
3. docker registry - persistent from ../nine/registry-compose.yml
4. 4x tomcats on docker - persistent from ../nine/teamcity-compose.yml
5. old-school tomcat for grails3demo.greenbill.com, not currently used.
6. scripts used by teamcity for deploying from old linode box

It would be easy to reload the system from the linode control panel to ensure that nothing is done outside of docker.