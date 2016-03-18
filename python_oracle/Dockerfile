FROM centos:7

# install crontabs
RUN yum makecache && yum install crontabs gcc make unzip python-devel libaio -y \
    && yum clean all

# install instantclient and cx_Oracle
ADD ["instantclient-basic-linux.x64-11.2.0.4.0.zip", \
     "instantclient-sdk-linux.x64-11.2.0.4.0.zip", \
     "cx_Oracle-5.2.tar.gz", \
     "crontab", \
     "/root/"]
WORKDIR /root/
ENV ORACLE_HOME /root/instantclient_11_2
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$ORACLE_HOME

RUN unzip instantclient-basic-linux.x64-11.2.0.4.0.zip \
    && unzip instantclient-sdk-linux.x64-11.2.0.4.0.zip \
    && ln -s $ORACLE_HOME/libclntsh.so.11.1 $ORACLE_HOME/libclntsh.so \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && cd cx_Oracle-5.2 && python setup.py build && python setup.py install \
    && crontab /root/crontab 

# Jobs triggered hourly by crond
VOLUME /etc/cron.hourly/
CMD ["/usr/sbin/crond", "-n"]
