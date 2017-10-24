#!/bin/bash
#Install monit,created by SunLihui @2017-10-24 in tuhu

yum install -y epel-release && yum install -y monit
VERSION=`cat /etc/redhat-release |cut -d'.' -f1|awk '{print $NF}'`

if [ $VERSION == 6 ]
then
mv /etc/monit.conf /etc/monit.conf-ori
mv monitrc /etc/monit.conf
mv {mail,check_program,program.sh} /etc/monit.d/
chmod 0700 /etc/monit.conf
mkdir /var/certs
cd /etc/pki/tls/certs
./make-dummy-cert monit.pem
cp monit.pem /var/certs
chmod 0400 /var/certs/monit.pem
mkdir /var/monit

monit -t&&/etc/init.d/monit start

elif [ $VERSION == 7 ]
then
mv /etc/monitrc /etc/monitrc-ori
mv monitrc /etc/monitrc
mv {mail,check_program,program.sh} /etc/monit.d/
chmod 0700 /etc/monitrc
mkdir /var/certs
cd /etc/pki/tls/certs
./make-dummy-cert monit.pem
cp monit.pem /var/certs
chmod 0400 /var/certs/monit.pem
mkdir /var/monit

moint -t && systemctl start monit

else 
echo "System unknow,will quit........"
fi
