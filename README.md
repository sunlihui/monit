# monit
监控服务的利器

安装：
首先为了https访问创建自签证书 monit.pem
1. # mkdir /var/certs
2.cd /etc/pki/tls/certs
3../make-dummy-cert monit.pem
4.cp monit.pem /var/certs
5.chmod 0400 /var/certs/monit.pem
创建运行文件夹：mkdir /var/monit

配置：
monitrc 请替换 /etc/monitrc
mail check_program 请放入 /etc/monit.d/

启动：
检测配置文件： monit -t 
启动： systemctl  start monit
