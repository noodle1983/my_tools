#!/bin/bash

gs_pid=`ps -ef|grep [g]ameserver_20007.lua |awk -e '{print $2;}'`
kill -10 ${gs_pid}
while [ "$gs_pid" != "" ]
do
        echo "wait gs to stop, pid:${gs_pid}"
        sleep 1
        gs_pid=`ps -ef|grep [g]ameserver_20007.lua |awk -e '{print $2;}'`
done

db_pid=`ps -ef|grep [d]bserver_20007.lua |awk -e '{print $2;}'`
kill -10 ${db_pid}
while [ "$db_pid" != "" ]
do
        echo "wait db to stop, pid:${db_pid}"
        sleep 1
        db_pid=`ps -ef|grep [d]bserver_20007.lua |awk -e '{print $2;}'`
done

