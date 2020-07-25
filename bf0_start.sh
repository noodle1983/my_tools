#!/bin/bash

bf0_pid=`ps -ef|grep bfserverbf_ap[p] |awk -e '{print $2;}'`
if [ "$bf0_pid" != "" ]
then
        echo "bf0 already started with pid:${bf0_pid}"
else
        cd inc_rel/bfserver/
	./bfserverbf_app -c bfserver_0.lua
        cd -
        sleep 1
	bf0_pid=`ps -ef|grep bfserverbf_ap[p] |awk -e '{print $2;}'`
        if [ "$bf0_pid" == "" ]
        then
                echo "bf0 can't be started."
                exit -1
        else
                echo "bf0 started with pid:${bf0_pid}."
        fi
fi


