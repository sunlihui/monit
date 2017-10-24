# monit
监控服务的利器

安装：
首先为了https访问创建自签证书 monit.pem
mkdir /var/certs
cd /etc/pki/tls/certs
./make-dummy-cert monit.pem
cp monit.pem /var/certs
chmod 0400 /var/certs/monit.pem
mkdir /var/monit


配置：
monitrc 请替换 /etc/monitrc
chmod 0700 /etc/monitrc
mail check_program 请放入 /etc/monit.d/

启动：
检测配置文件： monit -t 
启动： systemctl  start monit
