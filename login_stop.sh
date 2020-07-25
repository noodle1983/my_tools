#!/bin/bash

lg_pid=`ps -ef|grep [l]oginserverlogin_app |awk -e '{print $2;}'`
kill -10 ${lg_pid}
while [ "$lg_pid" != "" ]
do
        echo "wait login to stop, pid:${lg_pid}"
        sleep 1
	lg_pid=`ps -ef|grep [l]oginserverlogin_app |awk -e '{print $2;}'`
done
