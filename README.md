# monit
监控服务及程序的工具
官网地址：https://mmonit.com/monit/
ps：看到其他地方都说软件是收费的，不过实际使用过程中，并未发现需要购买的情况(⊙o⊙)…

安装：
1） yum install monit（提前安装好epel源“yum install -y epel-release”）最新的版本请去官网下载

配置：
1） 首先为了https访问创建自签证书 monit.pem：
mkdir /var/certs
cd /etc/pki/tls/certs
./make-dummy-cert monit.pem
cp monit.pem /var/certs
chmod 0400 /var/certs/monit.pem
mkdir /var/monit

2）主配置文件：
monitrc，实际使用请替换/etc/monitrc文件，mail check_program 请放入 /etc/monit.d/，权限调整： chmod 0700 /etc/monitrc
monitrc,mail,check_program请见下面详解：
#######################################################################################
set daemon  30              # 检查周期，默认为2分钟，可以根据需要自行调节，这里把它改成30秒。
set logfile syslog          # 日志文件

set httpd port 2812 and     # 设置http监控页面的端口
    SSL ENABLE
    PEMFILE /var/certs/monit.pem
    #use address 0.0.0.0    # only accept connection from localhost
    allow 10.1.0.0/16       # allow localhost to connect to the server and
    allow admin:monit       # require user 'admin' with password 'monit'

    check system localhost            #这里localhost请改成机器名，增加可读性，下面是对系统的监控
    if loadavg (1min) > 10 then alert
    if loadavg (5min) > 6 then alert
    if memory usage > 80% then alert
    if cpu usage (user) > 80% then alert
    if cpu usage (system) > 60% then alert
    if cpu usage (wait) > 75% then alert

include /etc/monit.d/*
#######################################################################################
    set mailserver  smtp.126.com  username "" password ""  # 邮件服务器配置
    set mailserver  smtp.qq.com  username "" password ""
    set mail-format {                                      # 邮件格式
     from: test@126.com
     subject: $SERVICE $EVENT at $DATE on $HOST
     message: Monit $ACTION $SERVICE $EVENT at $DATE on $HOST : $DESCRIPTION.
           Yours sincerely,
              Monit
      }
    set alert *@qq.com                                    # 邮件接收者

    set idfile /var/monit/id
    set eventqueue
         basedir /var/monit
#######################################################################################
#!/bin/bash
DIR=
PROGRAM=Launcher
cd ${DIR}
#mvn clean install -DskipTests

export MAVEN_OPTS="-Xms2048m -Xmx2048m -Xmn800m -XX:MaxMetaspaceSize=256m -Xss256k -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:AutoBoxCacheMax=20000 -XX:-OmitStackTraceInFastThrow"

case $1 in 
start)
nohup mvn jetty:run -Dip=* >>logs/collector.log 2>&1 &
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
#######################################################################################

启动：
检测配置文件： monit -t 
启动： systemctl  start monit


