#!/bin/bash
#Author: qifa.zhao@dianping.com
#Date: 2013-08-20

#build trust工具，适用于CentOS机器间建立信任

SSH_HOME_DIR="$HOME/.ssh"
TMP_FILE="$SSH_HOME_DIR/.tmp_authorized_keys"

function help
{
    echo "Usage: $0 host user password [port,default 22]"
    exit 0
}

#install sshpass
function install_sshpass
{
    which sshpass
    if [ $? -eq 0 ];then
        echo "sshpass installed already, no need to install again."
    else
        echo "Install sshpass begin ..."
        yes|yum install sshpass
        if [ $? -ne 0 ];then
        	echo "Install sshpass succeed!"
        else
        	echo "Install sshpass failed! No need to continue, exit!"
        	exit 1
        fi
    fi
}

function install_expect
{
    which expect && return 0
    host=$(lsb_release -i|awk '{print $3}')
    if [ "${host}" -eq "CentOS" ];then
        yum -y install expect #TODO: install expect for other system
    elif [ "${host}" -eq "Ubuntu" ];then
        apt-get install expect
    else
        echo "Unsupported operating system."
    fi
}

function wise_ssh
{
    passwd=$1
    cmd=${@:2}
    expect -c "set timeout 5;
            spawn ${cmd};
            expect *assword:*;
            send ${passwd}\r;
            interact;"
}

function main
{
    if [ $# -lt 2 ];then
        help $0
    fi
    host=${1}
    user=${2}
    password=${3}
    port=${4:-22}
    ssh -p $port -o BatchMode=yes -o StrictHostKeyChecking=no $user@$host "exit"
    if [ $? -eq 0 ];then
        echo "Trusted already, no need to do it again."
        return 0
    else
        echo "Will build trust between localhost and $host with user/password/port as $user/$password/$port ..."
    fi
    
    install_expect

    if [ ! -f $SSH_HOME_DIR/id_rsa.pub ];then
        ssh-keygen -t rsa -f $SSH_HOME_DIR/id_rsa -N ""
    fi

    >$TMP_FILE
    wise_ssh $password scp -P $port $user@$host:'\$HOME/.ssh/authorized_keys' $TMP_FILE

    chmod 644 $TMP_FILE
    sed -i "/$USER@$HOSTNAME/d" $TMP_FILE
    cat $SSH_HOME_DIR/id_rsa.pub >> $TMP_FILE

    wise_ssh $password ssh -p $port $user@$host 'mkdir -p \$HOME/.ssh && chmod 700 \$HOME/.ssh'
    wise_ssh $password scp -P $port $TMP_FILE $user@$host:'\$HOME/.ssh/authorized_keys'
    wise_ssh $password ssh -p $port $user@$host 'chmod 644 \$HOME/.ssh/authorized_keys'
    ssh -p $port -o BatchMode=yes -o StrictHostKeyChecking=no $user@$host "exit"
    if [ $? -eq 0 ];then
        echo "Build trust succeed!"
        return 0
    else
        echo "Unknown error!"
        return 1
    fi
}

main $@
