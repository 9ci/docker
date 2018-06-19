# Linode2 box -- ln02.9ci.com

This document describes everything done to ln02.9ci.com.

# Tasks

It would be easy to reload the system from the linode control panel to ensure that nothing is done outside of docker.

## Get rancher setup on linode

https://rancher.com/docs/rancher/v1.6/en/quick-start-guide/ has the initial info

see https://linode.com/docs/applications/containers/how-to-deploy-apps-with-rancher/ It might be out of date as their script might not be needed.

### Install rancher

```
docker run -d --name rancher --restart=unless-stopped -p 8080:8080 rancher/server:stable
```

Now, for the hostname to use going forward, you need on of (in order of preference first)
1. A public IP address (NOT A NAME!)
2. A non-routable ip address like 192.168.x.y. (NOT LOCALHOST and NOT 127.0.0.1)

This is your __rancher_ip__.  It's important that you use this ip everywhere instead of some other thing that works with normal
networking.

__Browser site is now http://<rancher_ip>:8080__

### Add hosts

1. Web browser to rancher_ip
2. Add hosts button near the top of the screen
3. Add localhost. Click save.
	1. Add public ips and ports as necessary. _Use the IP ADDRESS, not the HOSTNAME_
	2. Re-run docker command as it shows up in the panel

## Create mysql 5.7

* innodb ___/etc/mysql/conf.d/9ci.cnf___
* utf-8  ___sql command___
* case-sensitive collation
* max\_connections ___datadir/database.properties___
* innodb\_buffer\_pool\_size=2000M
* innodb\_log\_file\_size=1024M
* innodb\_file\_per\_table

```
create database teamcity collate utf8_bin;
create user teamcity identified by '<password>';
grant all privileges on teamcity.* to 'teamcity';
grant process on *.* to teamcity;
```

## Create a latest teamcity in it

## Show us that it works


# Currently on the system

## Apps installed directly on the host

1. old-school tomcat for grails3demo.greenbill.com, not currently used.
2. scripts used by teamcity for deploying from old linode box
3. apache2 for \*.greenbill.com certificate and front-end for all the tomcats.

## Apps installed on docker

1. mysql on docker - persistent from ../nine/mysql-compose.yml
2. docker registry - persistent from ../nine/registry-compose.yml
3. 4x tomcats on docker - persistent from ../nine/teamcity-compose.yml
