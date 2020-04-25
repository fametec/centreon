FROM mariadb

MAINTAINER Eduardo Fraga <eduardo.fraga@fametec.com.br> 

ENV MYSQL_DATABASE centreon
ENV MYSQL_USER centreon
ENV MYSQL_PASSWORD centreon
ENV MYSQL_ROOT_PASSWORD centreon

RUN { \
	echo '[server]' ; \
	echo 'innodb_file_per_table=1' ; \
	echo 'open_files_limit=32000' ; \
    } > /etc/mysql/conf.d/99-centreon.cnf


VOLUME ["/var/lib/mysql"]


EXPOSE 3306


CMD ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]


