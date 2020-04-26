FROM centos:7.7.1908

RUN yum -y install centos-release-scl

RUN yum -y install http://yum-1.centreon.com/standard/19.10/el7/stable/noarch/RPMS/centreon-release-19.10-1.el7.centos.noarch.rpm

RUN yum -y install centreon-base-config-centreon-engine

RUN echo "date.timezone = Etc/UTC" > /etc/opt/rh/rh-php72/php.d/99-php-timezone.ini

RUN yum -y install centreon-widget*

RUN yum -y install nagios-plugins-all centreon-plugin*

RUN yum -y install openssh openssh-server openssh-clients && \
        mkdir -p /var/run/sshd && \
        echo 'root:centreon' | chpasswd && \
        ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
        ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
        ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
        ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key && \
        sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config

RUN yum -y install python-setuptools && easy_install supervisor

ADD scripts/supervisord.conf /etc/supervisord.conf

RUN { \
	echo 'CENTREON   ALL = NOPASSWD: /usr/bin/supervisorctl' ; \
    } >> /etc/sudoers.d/centreon-supervisor

RUN su - centreon-engine -c 'ssh-keygen -q -f /var/lib/centreon-engine/.ssh/id_rsa'

RUN yum -y install git expect \
		'perl(JSON::PP)' \
		'perl(Digest::MD5::File)' \
		'perl(NetAddr::IP)' \
		'perl(Schedule::Cron)' \
		'perl(Crypt::CBC)' \
		'perl(ZMQ::LibZMQ4)' \
		'perl(JSON::XS)' \
		'perl(YAML)' \
		'perl(DBD::SQLite)' \
		'perl(DBD::mysql)' \
		'perl(UUID)' \
		'perl(HTTP::Daemon)' \
		'perl(HTTP::Daemon::SSL)' \
		'perl(HTTP::Status)' \
		'perl(MIME::Base64)' && \
	git clone https://github.com/centreon/centreon-gorgone && \
	cd centreon-gorgone && \
	yum -y install \
		packaging/packages/perl-CryptX-0.064-1.el7.x86_64.rpm \
		packaging/packages/perl-YAML-LibYAML-0.80-1.el7.x86_64.rpm \
		packaging/packages/perl-Hash-Merge-0.300-1.el7.noarch.rpm \
		packaging/packages/perl-Clone-Choose-0.010-1.el7.noarch.rpm && \
	sed -i -e /more/d install.sh
	
COPY scripts/script.exp /centreon-gorgone/script.exp

RUN cd /centreon-gorgone && ./script.exp

RUN yum -y clean all && rm -rf /var/cache/yum

EXPOSE 22/TCP 80/TCP 162/UDP

CMD ["/usr/bin/supervisord"]

