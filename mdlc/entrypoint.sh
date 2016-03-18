#!/bin/bash
#########################################################################
# File Name: entrypoint.sh
# Author: Chufuyuan
# Mail: chufuyuan@live.cn
# Created Time: 二  9/15 11:35:28 2015
#########################################################################

set -ex

CODE_DIR=/opt/mdlc-node
USER=node

cd $CODE_DIR
if [ $# -eq 0 ]; then
# default behavior: build and serve mdlc-node
    su $USER -c "PATH=/usr/local/bundle/bin:$PATH;cd $CODE_DIR; bower install"     
	npm install
	npm link
    su $USER -c "PATH=/usr/local/bundle/bin:$PATH;cd $CODE_DIR; mdfe serve"
elif [ "${1:0:1}" = "-" ]; then
# arguments
	mdfe $1
elif [ _$1 = "_serve" -o _$1 = "_server" ]; then
# serve
    su $USER -c "PATH=/usr/local/bundle/bin:$PATH;cd $CODE_DIR; bower install"     
	npm install
	npm link
    su $USER -c "PATH=/usr/local/bundle/bin:$PATH;cd $CODE_DIR; mdfe serve"
fi

exec "$@"
