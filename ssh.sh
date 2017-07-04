#!/bin/bash 
#Author: qifa.zhao@dianping.com
#Date: 2013-07-18

ports=(22 60022)

if echo "$1" |grep "@" >/dev/null; then
    host=${1#*@}

    for p in ${ports[@]}
    do 
        if nc -z -G 3 ${host} ${p} >/dev/null 2>&1; then
            port=${p}
            break
        fi
    done

    if [[ "$port" != "" ]];then
        \ssh -p ${port} $@
    else 
        \ssh $@
    fi
else
    \ssh $@
fi
