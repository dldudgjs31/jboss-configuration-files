#!/bin/sh


. ./env.sh START

nohup ${JBOSS_HOME}/bin/standalone.sh -DSERVER=${SERVER_NAME} -c ${CONFIG_FILE} >> ${JBOSS_LOG_HOME}/nohup/${SERVER_NAME}.out 2>&1 &

if [ e${1} = "enotail" ]
then
    echo "Starting... JBoss SERVER - ${SERVER_NAME}"
    exit;
fi

sleep 3
tail -100f ${JBOSS_LOG_HOME}/server.log
