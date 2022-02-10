#!/bin/sh

. ./env.sh KILL

PID="`ps -ef | grep java | grep "SERVER=${SERVER_NAME}" | awk {'print $2'}`"
if [ "e${PID}" == "e" ]
then
	echo "JBoss SERVER - ${SERVER_NAME} is Not RUNNING..."
	exit;
	
fi

ps -ef | grep java | grep "SERVER=${SERVER_NAME}" | awk {'print "kill -9 " $2'} | sh -x
