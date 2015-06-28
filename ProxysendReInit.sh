#! /usr/local/bin/zsh 
cd /TopStor
logging='/usr/local/www/apache24/data/des19/Data/currentinfo2.log'
stamp=`echo $@ | awk '{print $1}'`;
dst=`echo $@ | awk '{print $2}'`;
pp=`echo $@ | awk '{print $3}'`;
inoutpp=`echo $@ | awk '{print $4}'`;
task=`ps -aux | grep $pp | awk '{print $2}' | wc -c `;
taskn=$((task+0));
if [[ $taskn -le 2 ]];
then
 echo socat TCP4-LISTEN:$pp,reuseaddr,forever TCP4-LISTEN:$inoutpp,reuseaddr,forever > txt/tmpsocat 
 /usr/local/bin/socat TCP4-LISTEN:$pp,reuseaddr,forever TCP4-LISTEN:$inoutpp,reuseaddr,forever &
 pp=$((pp+1)); inoutpp=$((inoutpp+1));
 /usr/local/bin/socat TCP4-LISTEN:$inoutpp,reuseaddr,forever TCP4-LISTEN:$pp,reuseaddr,forever &
 pp=$((pp+1)); inoutpp=$((inoutpp+1));
 /usr/local/bin/socat TCP4-LISTEN:$inoutpp,reuseaddr TCP4-LISTEN:$pp,reuseaddr 2>txt/socerr &
 echo /usr/local/bin/socat TCP4-LISTEN:$inoutpp,reuseaddr TCP4-LISTEN:$pp,reuseaddr > txt/zfs${pp}.txt 
 taskp=`ps -aux | grep $inoutpp | awk '{print $2}' | wc -c `;
 taskpn=$((taskp+0));
 if [[ $taskpn -le 2 ]];
 then
#  nc -lk $inoutpp < txt/out$pp > txt/in$pp &
 fi
# pp=$((pp+2));
# mkfifo txt/out$pp;
# nc -lk $pp  > txt/out$pp &
# ./ProxysendReClose.sh $pp $inoutpp &
# echo $stamp waiting waiting $stamp > out & 
 datenow=`date +%m/%d/%Y`; timenow=`date +%T`;
 logdata='Initializing_new_send_session_session';
 logthis=`./jsonthis3.sh Date $datenow time $timenow msg info user $partner data $logdata`;
 oldlog=`cat $logging | sed 's/]//g'`; newlog=$oldlog,$logthis]; echo $newlog > $logging;
 echo $datenow $timenow :$logdata > ${logging}2
 #echo $pp;
else
 echo $stamp waiting waiting $stamp > out & ; 
fi;
