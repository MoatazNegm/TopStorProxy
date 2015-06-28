#! /usr/local/bin/zsh 
cd /TopStor
md5old="hi"
while true;
do
 md5new=`md5 receiver.txt | awk '{ print $4}'`;
 if [[ md5new != md5old ]];
 then
  md5old=md5new;
  serviceoff=1;
 else
  serviceoff=0;
 fi
 while read -r line;
 do
  proxycomplete=`echo $line | awk '{ print NF }'`;
  if [[ $proxycomplete -ge 7 ]]; 
  then
   inoutpp=` echo $line | awk '{print $5}'`;
   pp=` echo $line | awk '{print $7}'`;
   task=`ps -auxw | grep "$pp" | awk '{print $2}' | wc -c `;
   taskn=$((task+0));
   if [[ $taskn -le 2 ]];
   then
    echo socat TCP4-LISTEN:$pp,reuseaddr,forever TCP4-LISTEN:$inoutpp,reuseaddr,forever > txt/tmpsocat 
    /usr/local/bin/socat TCP4-LISTEN:$pp,reuseaddr,forever TCP4-LISTEN:$inoutpp,reuseaddr,forever &
   fi
   pp=$((pp+1)); inoutpp=$((inoutpp+1));
   task=`ps -auxw | grep "$inoutpp" | awk '{print $2}' | wc -c `;
   taskn=$((task+0));
   if [[ $taskn -le 2 ]];
   then
    /usr/local/bin/socat TCP4-LISTEN:$inoutpp,reuseaddr,forever TCP4-LISTEN:$pp,reuseaddr,forever & ;
   fi
   pp=$((pp+1)); inoutpp=$((inoutpp+1));
   task=`ps -auxw | grep "$inoutpp" | awk '{print $2}' | wc -c `;
   taskn=$((task+0));
   if [[ $taskn -le 2 ]];
   then
    /usr/local/bin/socat TCP4-LISTEN:$inoutpp,reuseaddr TCP4-LISTEN:$pp,reuseaddr 2>txt/socerr &
    echo /usr/local/bin/socat TCP4-LISTEN:$inoutpp,reuseaddr TCP4-LISTEN:$pp,reuseaddr > txt/zfs${pp}.txt ;
   fi
  fi
 done < receiver.txt
done
