#! /usr/local/bin/zsh
cd /TopStor
mkfifo -m 660 /tmp/msgfile
mkfifo -m 600 /tmp/msgrack;
mkfifo -m 600 /tmp/msgremotefile;
export REMOTE=Topstor
./Topstorremote.sh &
./Topstorremoteack.sh &
chgrp moataz /tmp/msgfile; 
chown www /tmp/msgfile; 
#rm /TopStor/txt/*
ClearExit() {
	echo got a signal > /TopStor/txt/sigstatus.txt
	rm /tmp/msgfile
	rm /tmp/msgrack;
	rm /tmp/msgremotefile;
	ps -aux | grep /bin/nc | kill -9
	exit 0;
}
trap ClearExit HUP
while true; do 
{
read line < /tmp/msgfile
echo $line > /TopStor/tmpline
request=`echo $line | awk '{print $1}'`
reqparam=`echo $line | cut -d " " -f2-`
./$request $reqparam & 
}
done;
echo it is dead >/TopStor/txt/status.txt
