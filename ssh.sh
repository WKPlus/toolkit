#!/bin/bash 

host=${1#*@}

ports=(22 60022)
for p in ${ports[@]}
do 
    if nc -z -w3 ${host} ${p} >/dev/null; then
        port=${p}
        break
    fi
done

if [[ "$port" != "" ]];then
    ssh -p ${port} $@
else 
    ssh $@
fi
