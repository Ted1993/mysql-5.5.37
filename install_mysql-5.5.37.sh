#!/bin/bash

userdel www
groupadd www
useradd -g www -M -d /alidata/www -s /sbin/nologin www &> /dev/null


mkdir -p /data/log/mysql
chown -R www:www /data/log

mkdir -p /data/server/mysql-5.6.24
ln -s /data/server/mysql-5.6.24 /data/server/mysql



if [ `uname -m` == "x86_64" ];then
machine=x86_64
else
machine=i686
fi
if [ $machine == "x86_64" ];then
  rm -rf mysql-5.5.37-linux2.6-x86_64
  if [ ! -f mysql-5.5.37-linux2.6-x86_64.tar.gz ];then
	 wget http://test-oracle.oss-cn-hangzhou.aliyuncs.com/mysql-5.5.37-linux2.6-x86_64.tar.gz
  fi
  tar -xzvf mysql-5.5.37-linux2.6-x86_64.tar.gz
  mv mysql-5.5.37-linux2.6-x86_64/* /data/server/mysql
else
  rm -rf mysql-5.5.37-linux2.6-i686
  if [ ! -f mysql-5.5.37-linux2.6-i686.tar.gz ];then
    wget http://test-oracle.oss-cn-hangzhou.aliyuncs.com/mysql-5.5.37-linux2.6-i686.tar.gz
  fi
  tar -xzvf mysql-5.5.37-linux2.6-i686.tar.gz
  mv mysql-5.5.37-linux2.6-i686/* /data/server/mysql
fi

groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
/data/server/mysql/scripts/mysql_install_db --datadir=/data/server/mysql/data/ --basedir=/data/server/mysql --user=mysql
chown -R mysql:mysql /data/server/mysql/
chown -R mysql:mysql /data/server/mysql/data/
chown -R mysql:mysql /data/log/mysql
\cp -f /data/server/mysql/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir=/data/server/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir=/data/server/mysql/data#' /etc/init.d/mysqld
#\cp -f /data/server/mysql/support-files/my-medium.cnf /etc/my.cnf
#sed -i 's#skip-external-locking#skip-external-locking\nlog-error=/data/log/mysql/error.log#' /etc/my.cnf
chmod 755 /etc/init.d/mysqld
#/etc/init.d/mysqld start
