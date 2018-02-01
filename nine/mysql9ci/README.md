# The mysql9ci image

* __You can't use mysql on your host AND on this docker container simultaneously as configured in this
project!__ See below about incompatibilities. This incompatibility is due to 9ci configuration, not the
official docker container.

There is important information in this README about installing and accessing the docker mysql. Please read
it.

## About the image

If the installation is _not_ a customer site, then we will have a mysql image. This is the
official mysql docker image, following the `5.7` tag. This image is based on Debian Linux so
there will be a somewhat larger footprint on your host because Debian is a full-scale
distribution.

This image has the following configuration changes:

* `lower_case_table_names=0`
* `default-storage-engine=innodb`
* `transaction-isolation=READ-COMMITTED`

# Installation planning

## Filesystem considerations

Mysql on Linux can be extremely slow in some circumstances. Those circumstances happen a lot
when you create the database. This includes mysql on docker.

There is a workaround which increases speed acceptably but it's not safe for production
sites. Google __mysql barrier=0__ to get in-depth information.

On Linux, the workaround involves creating a separate ext4 filesystem for /var/lib/mysql and
mounting it with the `barrier=0` option in `/etc/fstab` as below:


```
/dev/mapper/hddvg1-mysql                  /var/lib/mysql   ext4    defaults,barrier=0 0 2
```

You will need to do this with your system if you want acceptable mysql performance for testing
and development.

## Incompatibilities

The default location of database files on Linux is /var/lib/mysql. The mysql-compose.yml file creating the
container from this image maps /var/lib/mysql on the container to the same directory on the
host. If your host has mysql running, this will be a disaster.

What you can do:

1. Disable your mysql server on your host. (preferred)
2. Comment out the volume sharing on the yml file.

If you do map the docker container to /var/lib/mysql on your host, then all the databases you
created on your host mysql server will be available on your docker image.

# Accessing mysql container from host

You can't use localhost even though the port 3306 is mapped to your host! Mysql looks for 'localhost' or
`127.0.0.1` or `::1` and handles connections without networking if detected!

To access the mysql9ci instance from the host, you need to:

`mysql -h mysql9ci -u root -p`

__In order for this to work, you need some setup!__

* The docker mysql is running in a vm, which is NOT LOCALHOST TO YOU!
* The mysql command-line client handles localhost in a special way.
* `mysql -u root -p` __will not work!__
* Use `mysql -h mysql9ci -u root -p` instead.
* In order for this to work, you need to edit your static hosts file at `/etc/hosts`:

```
127.0.0.1    localhost mysql9ci
```

The above edit (appending 'mysql9ci' to the localhost entry in /etc/hosts) will allow you to
use the above command to access mysql in the docker container.

The issue is that mysql, when you connect to localhost or 127.0.0.1, will assume that the
server is running in the "current" host operating system. It tries to find a process ID and
communicate without using networking. It won't work because the file containing the process
ID is on the docker container, not the host OS, and the process is running in docker, not the
host OS.

By making the static hosts entry, you trick mysql into connecting as though it were a foreign
host, which is more correct than the assumption it's running on the host OS.
