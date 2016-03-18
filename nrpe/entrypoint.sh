#!/usr/bin/env bash
#########################################################################
# File Name: entrypoint.sh
# Author: Chufuyuan
# Mail: chufuyuan@live.cn
# Created Time: 日  9/20 02:27:30 2015
#########################################################################

set -e
PATH=/opt/nagios/bin:$PATH
BASE=/opt/nagios/
CFG=${BASE}/etc/nrpe.cfg

# set listening port
if [ ${PORT} ];then
    sed -i "s|server_port=.*|server_port=${PORT}|" ${CFG}
fi

# set the address nrpe bind to
sed -i "s|#server_address=.*|server_address=${HOSTNAME}|" ${CFG}

# set ip addrs that allowed to talk to NRPE
if [ ${ALLOWEDHOSTS} ];then
	sed -i "s|allowed_hosts=.*|allowed_hosts=${ALLOWEDHOSTS}|" ${CFG}
fi

# set whether or not NRPE will allow clients to specify args to commands
if [ ${DONTBLAMENRPE} ];then
	sed -i "s|dont_blame_nrpe=.*|dont_blame_nrpe=${DONTBLAMENRPE}|" ${CFG}
fi

# add include_dir = /conf
sed -i 's|#include_dir=<somed.*|include_dir=/conf|' ${CFG}

wait_pid(){
  while true; do
	  sleep 60
  done
}

# running in daemon mode cause the pid=1 process exit
nrpe -c ${CFG} -d
 
# keeps pip=1 running
wait_pid
