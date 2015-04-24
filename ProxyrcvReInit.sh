#! /usr/local/bin/zsh 
logging='/usr/local/www/apache24/data/des19/Data/currentinfo2.log'
stamp=`echo $@ | awk '{print $1}'`;
dst=`echo $@ | awk '{print $2}'`;
pp=`echo $@ | awk '{print $3}'`;
task=`ps -aux | grep $pp | awk '{print $2}' | wc -c `;
taskn=$((task+0));
if [[ $taskn -le 2 ]];
then
 mkfifo txt/in$pp;
 mkfifo txt/out$pp;
 nc -lk $pp < txt/in$pp > txt/out$pp &
 echo waiting > txt/in$pp &;
 receiver=`cat receiver.txt | grep -w "$stamp"`;
 receivers=` cat receiver.txt | grep -v -w "$stamp" `;
 echo $receivers > receiver.txt;
 echo $receiver $pp >> receiver.txt
 pp=$((pp+2));
 mkfifo txt/in$pp;
 mkfifo txt/out$pp;
 nc -lk $pp < txt/in$pp > txt/out$pp &
 echo waiting > txt/in$pp &;
 datenow=`date +%m/%d/%Y`; timenow=`date +%T`;
 logdata='Initializing_new_send_session_session';
 logthis=`./jsonthis3.sh Date $datenow time $timenow msg info user $partner data $logdata`;
 oldlog=`cat $logging | sed 's/]//g'`; newlog=$oldlog,$logthis]; echo $newlog > $logging;
 echo $datenow $timenow :$logdata > ${logging}2
 #echo $pp;
else
 echo $stamp waiting waiting $stamp > out & ; 
fi;
