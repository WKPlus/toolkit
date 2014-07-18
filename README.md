## Description
This is a repository for small tools used to improve efficiency

### Usage of ssh.sh
If you need to use `ssh` to remote login to several systems that listening on
different ports.

Such as: 
 - sshd on system1 listening on port 22
 - sshd on system2 listening on port 60022
 - sshd on system3 listening on port 61022

So you may use `ssh -p22 user@system1` or `ssh -p60022 user@system2` ... to
remote login to those systems.

It's boring to type `-pxx` everytime, isn't it?

Now all you have to do is run `alias ssh="path/to/ssh.sh"` first and then you
can remote login like this: `ssh user@system1` or `ssh user@system2`


### Usage of scp.sh 
Similar as `ssh.sh`, it's useful when there are several systems on which `sshd`
listening on different ports.

Beforce use `scp.sh`, I need to add `-Pxx` to `scp` command. And with it, you
can forget about it.
