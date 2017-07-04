#!/bin/bash
#Author: qifa.zhao@dianping.com
#Date: 2013-07-18

ports=(22 60022)

#find host in a scp command
for param in "$@"
do 
    if echo ${param} | grep "@.*:" >/dev/null; then
        host=$(echo ${param} | sed -E 's/.*@(.*):.*/\1/')
        break
    fi
done

if [[ "${host}" != "" ]];then
    #test port in list one by one
    for p in ${ports[@]}
    do 
        if nc -z -G 3 ${host} ${p} >/dev/null 2>&1; then
            port=${p}
            break
        fi
    done
fi

if [[ "${port}" != "" ]];then
    \scp -P ${port} $@
else
    \scp $@
fi
