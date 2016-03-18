FROM centos:7


EXPOSE 5666

# customed configurations and plugins lives here
VOLUME /conf

ADD ["nrpe-2.15.tar.gz", "nagios-plugins-2.1.1.tar.gz", "epel.repo","entrypoint.sh", "/root/"]

# nrpe runs as user nagios
RUN useradd nagios -s /bin/false

# install packages
RUN cp /root/epel.repo /etc/yum.repos.d/ \
    && yum makecache && yum install gcc make perl openssl openssl-devel -y \
    && yum clean all

# compile nrpe and plugins
RUN cd /root/nagios-plugins-2.1.1 \
    && ./configure --prefix=/opt/nagios --with-nagios-user=nagios --with-nagios-group=nagios \
    && make && make install \
    && cd /root/nrpe-2.15 \
    && ./configure  --prefix=/opt/nagios --with-nrpe-port=5666 --with-nagios-user=nagios \
       --with-nagios-group=nagios --with-nrpe-user=nagios --with-nrpe-group=nagios --enable-command-args \
    && make all && make install-daemon && make install-daemon-config \
    && rm -rf /root/nagios-plugins-2.1.1 /root/nrpe-2.15 \
    && chmod +x /root/entrypoint.sh


ENTRYPOINT ["/root/entrypoint.sh"]
