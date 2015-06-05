FROM registry.wpython.com/centos:6.6

MAINTAINER xuqiangqiang "739827282@qq.com"

RUN  yum -y install tar gcc-c++ supervisor ncurses-devel libtool bison bison-devel libaio libaio-devel

env MYSQL_BIN  /data/server/mysql/bin

ADD ./install_mysql-5.5.37.sh	/root/tools/install_mysql-5.5.37.sh
ADD ./supervisord.conf		/etc/supervisord.conf

WORKDIR /root/tools/

RUN sh install_mysql-5.5.37.sh

ADD ./my.cnf	/data/server/mysql/etc/

EXPOSE 22 3306

CMD ["/usr/bin/supervisord"]


