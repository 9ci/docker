# Linode2 box -- ln02.9ci.com

This document describes how to install rancher on ln02.9ci.com.

# Task Overview

Following instructions from:

* https://rancher.com/docs/rancher/v2.x/en/quick-start-guide/
* https://linode.com/docs/applications/containers/how-to-deploy-apps-with-rancher/

1. Setup DNS
2. Prepare a host
3. Get Rancher

# Setup DNS

Add a CNAME record for rancher.9ci.com to point to ln02.9ci.com.

# Prepare a Linux host

Start with a brand new 64-bit Ubuntu 16.04 

```
# Starting with the latest stuff
sudo apt update
sudo apt upgrade

# Install docker
sudo apt install docker.io
sudo usermod -aG docker <YOURUSER>
```

The following is an optional grab for command-line tools I use in every Linux or Mac box. It has no ultimate affect on the rancher install but takes little time and provides a lot of things I use:

```
# Install other handy tools
sudo apt install vim-nox
sudo apt install git
sudo apt install tmux

# This part installs convenient aliases and shell scripts.
git checkout git@github.com:ken-roberts/krstuff.git
sudo mv krstuff /usr/local/
cp -rax /usr/local/krstuff/skel/Linux ~/.krstuff
echo "# Pull in krstuff profile" >> ~/.bash\_profile
echo '[[ -s "$HOME/.krstuff/profile" ]] && source "$HOME/.krstuff/profile"' >> ~/.bash\_profile
. ~/.bash\_profile
```


# Get rancher

```
docker run -d --name rancher --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
```

## Configuring rancher

1. Open a web browser and enter the ip address of your host: https://<server_ip>. Replace <server_ip> with your host IP address
2. When prompted, create a password for the default admin account there
3. Set the __Rancher Server URL__ to __rancher.9ci.com__. This must be reachable by every rancher node
4. Clusters: __Add cluster__
5. Choose __Custom__
6. Enter __Cluster Name__ as ___9ciTesting___
7. Skip __Member Roles__ and __Cluster Options__
8. Click __Next__
9. From __Node Role__, select all the roles (etcd, Control, Worker)
10. Node Address section, the public address should be the ip for ln02.9ci.com. The internal address should be docker0 or whatever we create for the teamcity testing suite
11. There is a command displayed on the screen in a big black box. Copy it and paste it into an ssh session on ln02.9ci.com
12. When the command completes, click the __Done__ button on the browser control panel page.
13. Wait for the cluster state to say __Active__. The rancher task in the process list will be using significant CPU time while it's provisioning so you can watch it in the __top__ command line tool.
