#!/bin/bash

db_pid=`ps -ef|grep [d]bserver_20007.lua |awk -e '{print $2;}'`
if [ "$db_pid" != "" ]
then
        echo "db 20007 already started with pid:${db_pid}"
else
        cd inc_rel/dbserver/
        ./dbserverdb_app -c dbserver_20007.lua
        cd -
        sleep 1
        db_pid=`ps -ef|grep [d]bserver_20007.lua |awk -e '{print $2;}'`
        if [ "$db_pid" == "" ]
        then
                echo "db 20007 can't be started."
                exit -1
        else
                echo "db 20007 started with pid:${db_pid}."
        fi
fi


game_pid=`ps -ef|grep [g]ameserver_20007.lua |awk -e '{print $2;}'`
if [ "$game_pid" != "" ]
then
        echo "game 20007 already started with pid:${game_pid}"
else
        cd inc_rel/gameserver/
        ./gameservergame_app -c gameserver_20007.lua
        cd -
        sleep 1
        game_pid=`ps -ef|grep [g]ameserver_20007.lua |awk -e '{print $2;}'`
        if [ "$game_pid" == "" ]
        then
                echo "game 20007 can't be started."
                exit -1
        else
                echo "game 20007 started with pid:${game_pid}."
        fi
fi

