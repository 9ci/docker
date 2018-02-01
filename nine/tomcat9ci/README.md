# The tomcat9ci image

The tomcat9ci image comes from the official docker tomcat image supplied by apache.

It follows the latest 8.5-jre8-slim tag, which will periodically recieve updates. Those updates
can be pulled to your containers to provide the latest tomcat fixes for that version sequence.

The directories we care about are:

* `/var/9ci/rootLocation`
* `/usr/local/tomcat/logs`
* `/usr/local/tomcat/webapps`

These directories will be mapped to some host directory.

## Alpine Linux

This section will only apply to you if you need to get a shell into the __tomcat9ci__
container.

The tomcat image we use starts with the Alpine linux distribution as a base. This is an
extremely tiny version of Linux, which makes the system lightweight and quick to load. It also
has __busybox__ versions of almost all the commands. Busybox is designed to be tiny, so many
features of the commands you might use in this container have only a small subset of options.
