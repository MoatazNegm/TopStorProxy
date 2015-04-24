#! /usr/local/bin/zsh
logging='/usr/local/www/apache24/data/des19/Data/currentinfo2.log'
pp=`echo $@ | awk '{print $1}'`;
inoutpp=`echo $@ | awk '{print $2}'`;
e="waiting";
while [[ $e != "done" ]]; do read -r line; 
e=$line;
done < txt/out$pp; 
pxp=$(( pp-2 ));
k=`ps -auxw | grep -w "$pxp" | awk '{print $2}'`;
echo $k | xargs kill -9
k=`ps -auxw | grep -w "$pp" | awk '{print $2}'`; 
echo $k | xargs kill -9
rm -fd txt/out$pp;
rm -fd txt/in$pp;
rm -fd txt/out$pxp;
rm -fd txt/in$pxp;
datenow=`date +%m/%d/%Y`; timenow=`date +%T`;
logdata='Closing Session';
logthis=`./jsonthis3.sh Date $datenow time $timenow msg info user $partner data $logdata`;
oldlog=`cat $logging | sed 's/]//g'`; newlog=$oldlog,$logthis]; echo $newlog > $logging;
echo $datenow $timenow :$logdata > ${logging}2
#echo $pp;
