#!/bin/sh

. ./env.sh JBOSS-CLI

PID="`ps -ef | grep java | grep "SERVER=${SERVER_NAME}" | awk {'print $2'}`"
if [ "e${PID}" == "e" ]
then
        echo "JBoss SERVER - ${SERVER_NAME} is Not RUNNING..."
        exit;

fi

${JBOSS_HOME}/bin/jboss-cli.sh --connect --controller=${MGMT_ADDR}:${CLI_PORT} --connect $@

