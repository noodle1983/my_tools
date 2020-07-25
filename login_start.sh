#!/bin/bash

lg_pid=`ps -ef|grep [l]oginserverlogin_app |awk -e '{print $2;}'`
if [ "$lg_pid" != "" ]
then
        echo "login already started with pid:${lg_pid}"
else
        cd inc_rel/loginserver/
	./loginserverlogin_app -c loginserver.lua
        cd -
        sleep 1
        lg_pid=`ps -ef|grep [l]oginserverlogin_app |awk -e '{print $2;}'`
        if [ "$lg_pid" == "" ]
        then
                echo "login can't be started."
                exit -1
        else
                echo "login started with pid:${lg_pid}."
        fi
fi


