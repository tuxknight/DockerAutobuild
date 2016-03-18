.. _README:

Nagios NRPE
============

This NRPE plugin which installed /opt/nagios was bootstrapped from source code. nagios-plugins also installed to /opt/nagios.

Customed configurations and plugins are supported. 

Examples
-------------

::

  $ cat customed.cfg
  command[check_stats]=/conf/check_stats -w 2 -c 3

  $ ls /root/conf
  customed.cfg check_stats

  $ docker run -d -e ALLOWEDHOSTS=remote_ip -e PORT=5666 -v /root/conf:/conf nrpe:latest


Environments
--------------

::

  PORT - listening port

  ALLOWEDHOSTS - nagios server

  DONTBLAMENRPE - (0/1) set whether or not nrpe allows clients to specify args 0:false 1:true

Best practise for systemd
------------------------------

Since almost all of the majority distributions have moved to ``systemd`` , it is a convenient way to manage docker containers using ``systemd`` .

define service::

  $ cat /etc/systemd/system/nrpe.service
  [Unit]
  Description=nrpe
  After=docker.service
  Requires=docker.service
  
  [Service]
  TimeoutStartSec=0
  EnvironmentFile=/etc/sysconfig/nrpe
  ExecStartPre=-/usr/bin/docker kill nrpe01
  ExecStartPre=-/usr/bin/docker rm nrpe01
  # ExecStartPre=/usr/bin/docker pull nrpe
  ExecStart=/usr/bin/docker run --name nrpe01 $OPTIONS nrpe:latest
  
  [Install]
  WantedBy=multi-user.target
  

set configurations::

  $ cat /etc/sysconfig/nrpe
  #
  # set options for nrpe, 
  # only docker run options are supported
  # examples:
  #    -e ALLOWEDHOSTS=127.0.0.1,10.162.58.123
  #    -v /root/nrpe:/conf
  #    -p 5666:5666
  
  OPTIONS="--restart=always -e ALLOWEDHOSTS=127.0.0.1,10.162.58.123 -e PORT=5666 -p 5666:5666 -v /root/nrpe:/conf"
