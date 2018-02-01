FROM mysql:5.7

MAINTAINER Ken Roberts <kroberts@9ci.com>

RUN echo '[mysqld]'                              > /etc/mysql/conf.d/9ci.cnf
RUN echo 'default-storage-engine=innodb'        >> /etc/mysql/conf.d/9ci.cnf
RUN echo 'lower_case_table_names=0'             >> /etc/mysql/conf.d/9ci.cnf
RUN echo 'transaction-isolation=READ-COMMITTED' >> /etc/mysql/conf.d/9ci.cnf

EXPOSE 3306
