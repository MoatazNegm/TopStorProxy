#! /usr/local/bin/zsh
cd /TopStor
ClearExit() {
	echo got a signal > /TopStor/txt/sigstatusremote.txt
	kill -9 `ps -ef | grep nc  | awk '{print $1}'`
	exit 0;
}
trap ClearExit HUP
/sbin/sysctl net.inet.tcp.msl=2500
oldstamp=();
rcvoldstamp="007";
sndoldstamp="007"
while true; do
{
 nc -l 2234 | gunzip | openssl enc -d -aes-256-cbc -a -A -k SuperSecretPWD  > /tmp/msgremotefile  &
 read line < /tmp/msgremotefile;
 echo $line > /TopStor/tmplineremote
 linecomplete=` echo $line | tr -dc " " | wc -c `;
 if [[ $linecomplete -ge 7 ]];
 then
  stamp=`echo $line | awk '{print $2}'`
  request=`echo $line | awk '{print $1}'`
  receiver=`echo $line | awk '{print $3}'`
  license=`echo $line | awk '{print $4}'`;
  fromtype=`echo $line | awk '{print $5}'`;
  pp=`echo $line | awk '{print $7}'`;
  passphrase=`echo $line | awk '{print $8}'`;
  if [[ $stamp != $oldstamp[$pp] ]]; then 
   if [[ $fromtype == 'ProxysendReInit.sh' ]];
   then
    oldstamp[$pp]=$stamp;
    echo $oldstamp[$pp] is $stamp >> txt/proxystamp;
    searchs=${request}' '${receiver}
    isreceivero=`cat receiver.txt | grep -w "$searchs" | grep -w "$passphrase" | awk -F"$license"  '{print $1}'`;
    isreceiveron=`echo $isreceivero | wc -c`;
    isreceiveron=$((isreceiveron+0));
    if [[ $isreceiveron -ge 3 ]];
    then
     leftlines=`cat receiver.txt | grep -v -w "$searchs" `
     echo $leftlines > receiver.txt
     echo $isreceivero $license $pp $stamp >> receiver.txt 
     inoutpp=`echo $isreceivero | awk '{print $5}'`;
     reqparam=`echo $line | awk '{$1=$2=$3=$4=""; print substr($0,5) }'`;
     instr=`echo $reqparam | awk '{print $1 }'`;
     oper=`echo $reqparam | awk '{$1=""; print substr($0,2) }'`;
     ./$instr $stamp ${receiver} $pp $inoutpp > tmpl &;
     echo ./$instr $stamp ${receiver} $pp $inoutpp > tmpl &;
    else
     echo $stamp waiting receiver > out &
    fi
   fi
  fi
  if [[ $stamp != $oldstamp[$pp] ]]; then 
   if [[ $fromtype == 'ProxyrcvReInit.sh' ]];
   then
    oldstamp[$pp]=$stamp;
    echo old is $oldstamp[$pp] is $stamp >> txt/proxystamp;
    licensed=`cat license.txt | grep -w "$license" | wc -c `;
    echo $licensed >> tmplineremote
    if [[ $licensed -ge 4 ]];
    then
     searchs=${receiver}' '${request}
     receivers=` cat receiver.txt | grep -v -w "$searchs"`;
     echo $receivers > receiver.txt;
     thissender=` cat receiver.txt | grep -w "$searchs" | awk -F"$license" '{$1=""; print substr($0,2)}'`;
     echo $receiver $request $stamp $passphrase $pp $license $thissender >> receiver.txt
     echo $stamp waiting sender > out &
    else
     echo $stamp Not_Authorized > out &
    fi
   fi
  fi;
 fi
}
done;
echo it is dead >/TopStor/txt/statusremote.txt
