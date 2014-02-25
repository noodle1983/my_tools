#!/bin/bash
rebase_result=`git svn rebase|wc -l`
if [ "$rebase_result" == "1" ]; then
#    echo "`date` no update"
    exit -1
fi

echo ""
echo "--------------------------------------------------"
echo "`date` update to git"
expect <<END_OF_EXPECT
set timeout 60
spawn git push
expect "id_rsa"
send "aaaaaa\r"
wait
END_OF_EXPECT

expect <<END_OF_EXPECT
set timeout 60
spawn git push test
expect "id_rsa"
send "aaaaaa\r"
wait
END_OF_EXPECT
