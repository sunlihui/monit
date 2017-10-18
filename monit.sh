#!/bin/bash
DIR=
PROGRAM=Launcher
cd ${DIR}
#mvn clean install -DskipTests

export MAVEN_OPTS="-Xms2048m -Xmx2048m -Xmn800m -XX:MaxMetaspaceSize=256m -Xss256k -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:AutoBoxCacheMax=20000 -XX:-OmitStackTraceInFastThrow"

case $1 in 
start)
nohup mvn jetty:run -Dip=ip >>logs/collector.log 2>&1 &
sleep 1
PID=`/usr/bin/jps |grep $PROGRAM|cut -d" " -f1`
echo $PID >/var/run/java.pid
#tail -f ${DIR}/logs/collector.log
;;
stop)
PID=`cat /var/run/java.pid` >/dev/null 2>&1
if [ -e /var/run/java.pid ] 
then kill -9 $PID
else echo "PID not find! please take care!"
fi
;;
status)
PID=`cat /var/run/java.pid` >/dev/null 2>&1
if [ -e /var/run/java.pid ]
then echo "Program is running,the pid is $PID"
else echo "Program is not running"
fi
;;
*)
echo "Usage:program (start|stop)"
;;
esac

