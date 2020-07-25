#!/bin/bash

bf0_pid=`ps -ef|grep bfserverbf_ap[p] |awk -e '{print $2;}'`
kill -10 ${bf0_pid}
while [ "$bf0_pid" != "" ]
do
        echo "wait bf0 to stop, pid:${bf0_pid}"
        sleep 1
	bf0_pid=`ps -ef|grep bfserverbf_ap[p] |awk -e '{print $2;}'`
done
