We want:

* A development environment
	* mysql of the appropriate version (currently 5.7)
		* lower_case_table_names=0
		* default-storage-engine=innodb
		* transaction-isolation=READ-COMMITTED
		* All this is in the default docker mysql:5.7
	* A local registry
		* https://docs.docker.com/registry/deploying/#run-a-local-registry
	* A tomcat9ci image

* 9ci source checked out, grails tools, etc
	* Developer supplies this?

* A customer-usable app server setup:
	* Start in your equivalent of /var/9ci
	* checkout this docker project
	* cd {/var/9ci}/docker/nine
	* docker-compuse up
	* This gets you:
	* rootLocation (you supply this)
	* tomcat9ci_app (from docker-compose)
	* tomcat9ci_api (from docker-compose)

