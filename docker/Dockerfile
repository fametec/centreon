FROM centos:7.7.1908

RUN yum -y install centos-release-scl

RUN curl -sSL 'http://yum.centreon.com/standard/19.04/el7/stable/noarch/RPMS/centreon-release-19.04-1.el7.centos.noarch.rpm' -o /tmp/centreon-release-19.04-1.el7.centos.noarch.rpm

RUN yum -y install --nogpgcheck /tmp/centreon-release-19.04-1.el7.centos.noarch.rpm

RUN yum -y install centreon

RUN echo "date.timezone = Etc/UTC" > /etc/opt/rh/rh-php71/php.d/php-timezone.ini

RUN yum -y install nagios-plugins-all centreon-plugin* centreon-widget*

RUN yum -y install openssh-server openssh-client && \
	mkdir -p /var/run/sshd && \
	echo 'root:centreon' | chpasswd && \
	sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config

RUN yum -y install python-setuptools && easy_install supervisor

ADD scripts/supervisord.conf /etc/supervisord.conf

EXPOSE 22 80

CMD ["/usr/bin/supervisord"]

