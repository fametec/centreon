FROM centos:7.7.1908

RUN yum -y install centos-release-scl

RUN yum -y install http://yum-1.centreon.com/standard/19.10/el7/stable/noarch/RPMS/centreon-release-19.10-1.el7.centos.noarch.rpm

RUN yum -y install centreon-poller-centreon-engine

RUN yum -y install \
	nagios-plugins-all \
	centreon-plugin* \
	centreon-widget*

RUN yum -y install openssh openssh-server openssh-clients && \
	mkdir -p /var/run/sshd && \
	echo 'root:centreon' | chpasswd && \
	ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
	ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
	ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
	ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key && \
	sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
                                                                                                                                                  
RUN su - centreon-engine -c 'ssh-keygen -q -f /var/lib/centreon-engine/.ssh/id_rsa'

RUN yum -y install python-setuptools && easy_install supervisor

ADD scripts/supervisord.conf /etc/supervisord.conf


RUN { \
        echo 'CENTREON   ALL = NOPASSWD: /usr/bin/supervisorctl' ; \
    } >> /etc/sudoers.d/centreon-supervisor


EXPOSE 22

CMD ["/usr/bin/supervisord"]

