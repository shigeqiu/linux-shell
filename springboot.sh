#!/bin/bash

start_jar=$2
stop_grep_matching=$3
if [ "$1" = "" ];
then
    echo -e "\033[0;31m 未输入操作名 \033[0m  \033[0;34m {start|stop|restart|status} \033[0m"
    exit 1
fi

if [ "start_jar" = "" ];
then
    echo -e "\033[0;31m 未输入应用名 \033[0m"
    exit 1
fi

function start()
{
    count=`ps -ef |grep java|grep $stop_grep_matching|grep -v grep|wc -l`
    if [ $count != 0 ];then
        echo "start server $start_jar  is running... "
    else
        echo "start server  $start_jar  success..."
        BUILD_ID=dontKillMe nohup java -jar $start_jar   > out.log  2>&1 &
    fi
}

function stop()
{
    echo "stop server by  $stop_grep_matching "
    boot_id=`ps -ef |grep java|grep $stop_grep_matching|grep -v grep|awk '{print $2}'`
    count=`ps -ef |grep java|grep $stop_grep_matching|grep -v grep|wc -l`

    if [ $count != 0 ];then
        kill -9 $boot_id
	echo "kill the process $boot_id"	
    else
        echo "no need to kill the process"
    fi
  
}

function restart()
{
    stop
    sleep 2
    start
}

function status()
{
    count=`ps -ef |grep java|grep $stop_grep_matching|grep -v grep|wc -l`
    if [ $count != 0 ];then
        echo "$stop_grep_matching is running..."
    else
        echo "$stop_grep_matching is not running..."
    fi
}

case $1 in
    start)
    start;;
    stop)
    stop;;
    restart)
    restart;;
    status)
    status;;
    *)

    echo -e "\033[0;31m Usage: \033[0m  \033[0;34m sh  $0  {start|stop|restart|status}  {SpringBootJarName} \033[0m\033[0;31m Example: \033[0m\033[0;33m sh  $0  start esmart-test.jar \033[0m"
esac
