REM p4 set P4PORT={host:1666}
REM p4 set P4PASSWD={pass}
REM p4 set P4USER={user}
REM p4 set P4CHARSET=utf8
REM p4 set P4CLIENT={workspace}
REM git p4 clone {//path} {local_dir}
git config apply.ignorewhitespace change
git config core.longpaths true
git reset HEAD --hard
echo {pass}|p4 login
git p4 sync
git merge p4/master
pause
