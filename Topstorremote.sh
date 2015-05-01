#! /usr/local/bin/zsh
cd /TopStor
ClearExit() {
	echo got a signal > /TopStor/txt/sigstatusremote.txt
	kill -9 `ps -ef | grep nc  | awk '{print $1}'`
	exit 0;
}
trap ClearExit HUP
while true; do
{
nc -l 2234 | gunzip | openssl enc -d -aes-256-cbc -a -A -k SuperSecretPWD  > /tmp/msgremotefile  &
read line < /tmp/msgremotefile;
echo $line > /TopStor/tmplineremote
stamp=`echo $line | awk '{print $2}'`
request=`echo $line | awk '{print $1}'`
receiver=`echo $line | awk '{print $3}'`
license=`echo $line | awk '{print $4}'`;
fromtype=`echo $line | awk '{print $5}'`
if [[ $fromtype == 'ProxysendReInit.sh' ]];
then
 isreceivero=`cat receiver.txt | grep -w "$receiver" `;
 isreceiveron=`echo $isreceivero | wc -c`;
 isreceiveron=$((isreceiveron+0));
 if [[ $isreceiveron -ge 3 ]];
 then
  inoutpp=`echo $isreceivero | awk '{print $4}'`;
  reqparam=`echo $line | awk '{$1=$2=$3=$4=""; print substr($0,5) }'`;
  instr=`echo $reqparam | awk '{print $1 }'`;
  oper=`echo $reqparam | awk '{$1=""; print substr($0,2) }'`;
  ./$instr $stamp $oper $inoutpp > out &;
 else
  echo $stamp waiting receiver > out &
 fi
else
 licensed=`cat license.txt | grep -w "$license" | wc -c `;
 echo $licensed >> tmplineremote
 if [[ $licensed -ge 4 ]];
 then
  reqparam=`echo $line | awk '{$1=$2=$3=$4=""; print substr($0,5) }'`;
  instr=`echo $reqparam | awk '{print $1 }'`;
  oper=`echo $reqparam | awk '{$1=""; print substr($0,2) }'`;
  echo ./$instr $stamp $oper >> tmplineremote 
  ./$instr $stamp $oper &;
  receiver=`echo $line | awk '{print $1}'`
  receivers=` cat receiver.txt | grep -v -w "$receiver" `;
  echo $receivers > receiver.txt;
  echo $receiver $stamp $license >> receiver.txt
  echo $stamp waiting sender > out &
 else
  echo $stamp Not_Authorized > out &
 fi
fi
}
done;
echo it is dead >/TopStor/txt/statusremote.txt
