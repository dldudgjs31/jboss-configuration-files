#!/bin/sh


#[S]--------------------------------------------------#
#JAVA_HOME="/usr/lib/jvm/jre-1.8.0-openjdk-1.8.0.181-3.b13.el7_5.x86_64"
#JAVA_HOME="/opt/jdk/jdk1.8.0_181"
JBOSS_HOME="/opt/lotte/jboss-eap-7.3"
export JBOSS_HOME 
#--------------------------------------------------[E]#



#[S] JBoss Environment -------------------------------#
JBOSS_USER="root"
SERVER_HOME="/opt/lotte/jboss"
SERVER_NAME="node01"
JBOSS_LOG_HOME="${SERVER_HOME}/${SERVER_NAME}/logs"
#--------------------------------------------------[E]#



#[S] JBoss Configurations ======================================================================#
### Config File
#CONFIG_FILE="standalone.xml"
CONFIG_FILE="standalone-ha.xml"
#CONFIG_FILE="standalone-full-ha-test.xml"
#CONFIG_FILE="standalone-full.xml"
#CONFIG_FILE="standalone-full-ha.xml"

### Instance Name
HOST_NAME="`hostname`"
INSTANCE_NAME="${SERVER_NAME}_${HOST_NAME}"

### ADDR & PORT Setting
PORT_OFFSET="0"
BIND_ADDR="192.168.50.115"
MGMT_ADDR="192.168.50.115"
#let CLI_PORT="9999+${PORT_OFFSET}"
let CLI_PORT="9990+${PORT_OFFSET}"
MULTICAST_ADDR="230.0.0.4"
MESSAGING_GROUP_ADDR="231.7.7.7"

### JBoss Option
JBOSS_OPTS="${JBOSS_OPTS} -Djboss.node.name=${SERVER_NAME}"
JBOSS_OPTS="${JBOSS_OPTS} -Djboss.server.base.dir=${SERVER_HOME}/${SERVER_NAME}"
JBOSS_OPTS="${JBOSS_OPTS} -Djboss.server.log.dir=${JBOSS_LOG_HOME}"
JBOSS_OPTS="${JBOSS_OPTS} -Djboss.server.config.user.dir=${SERVER_HOME}/${SERVER_NAME}/configuration"
JBOSS_OPTS="${JBOSS_OPTS} -Djboss.socket.binding.port-offset=${PORT_OFFSET}"
JBOSS_OPTS="${JBOSS_OPTS} -Djboss.bind.address=${BIND_ADDR}"
JBOSS_OPTS="${JBOSS_OPTS} -Djboss.bind.address.management=${MGMT_ADDR}"

if [ "e${CONFIG_FILE}" == "estandalone-ha.xml" ] || [ "e${CONFIG_FILE}" == "estandalone-full-ha.xml" ];
then
    JBOSS_OPTS="${JBOSS_OPTS} -Djboss.default.multicast.address=${MULTICAST_ADDR}"
    JBOSS_OPTS="${JBOSS_OPTS} -Djboss.bind.address.private=${BIND_ADDR}"
fi
if [ "e${CONFIG_FILE}" = "estandalone-full.xml" ] || [ "e${CONFIG_FILE}" == "estandalone-full-ha.xml" ];
then
    JBOSS_OPTS="${JBOSS_OPTS} -Djboss.messaging.group.address=${MESSAGING_GROUP_ADDR}"
    JBOSS_OPTS="${JBOSS_OPTS} -Djboss.bind.address.private=${BIND_ADDR}"
fi

JBOSS_OPTS="${JBOSS_OPTS} -Djboss.modules.system.pkgs=org.jboss.byteman"
JBOSS_OPTS="${JBOSS_OPTS} -Dorg.jboss.as.logging.per-deployment=false"
JBOSS_OPTS="${JBOSS_OPTS} -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -Duser.country=KR -Duser.language=ko"
JBOSS_OPTS="${JBOSS_OPTS} -Dorg.jboss.weld.serialization.beanIdentifierIndexOptimization=false"
JBOSS_OPTS="${JBOSS_OPTS} "

### Java Option
JAVA_OPTS="-server "
#JAVA_OPTS="${JAVA_OPTS} -Xms1024m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=256m"
JAVA_OPTS="${JAVA_OPTS} -Xms1024m -Xmx1024m"
JAVA_OPTS="${JAVA_OPTS} -Djava.net.preferIPv4Stack=true"
JAVA_OPTS="${JAVA_OPTS} -Djava.awt.headless=true"
JAVA_OPTS="${JAVA_OPTS} -verbose:gc"
JAVA_OPTS="${JAVA_OPTS} -XX:+UseParallelGC"
#JAVA_OPTS="${JAVA_OPTS} -XX:+UseConcMarkSweepGC"
JAVA_OPTS="${JAVA_OPTS} -Xloggc:${JBOSS_LOG_HOME}/gclog/gc_${SERVER_NAME}.log"
JAVA_OPTS="${JAVA_OPTS} -XX:+PrintGCDetails"
#JAVA_OPTS="${JAVA_OPTS} -XX:+PrintGCTimeStamps"
JAVA_OPTS="${JAVA_OPTS} -XX:+PrintGCDateStamps"
JAVA_OPTS="${JAVA_OPTS} -XX:+PrintHeapAtGC"
JAVA_OPTS="${JAVA_OPTS} -XX:+HeapDumpOnOutOfMemoryError"
JAVA_OPTS="${JAVA_OPTS} -XX:HeapDumpPath=${JBOSS_LOG_HOME}/dump/hdp_${SERVER_NAME}.hprof"
JAVA_OPTS="${JAVA_OPTS} ${JBOSS_OPTS}"
#export JAVA_OPTS=" $JAVA_OPTS -Djboss.default.jgroups.stack=udp"

#export JAVA_OPTS=" $JAVA_OPTS -Djboss.default.multicast.address=$MULTICAST_ADDR"
export JAVA_OPTS
#============================================================================================[E]#



#[S] Environment ECHO ==========================================================================#
if [ "e$1" != "enoecho" ]
then
    echo "================================================================================"
    echo "JAVA_HOME=${JAVA_HOME}"
    echo "JBOSS_HOME=${JBOSS_HOME}"
    echo "SERVER_HOME=${SERVER_HOME}"
    echo "SERVER_NAME=${SERVER_NAME}"
    echo "INSTANCE_NAME=${INSTANCE_NAME}"
    echo "JBOSS_LOG_HOME=${JBOSS_LOG_HOME}"
    echo "CONFIG_FILE=${CONFIG_FILE}"
    echo "PORT_OFFSET=${PORT_OFFSET}"
    echo "BIND_ADDR=${BIND_ADDR}"
    echo "MGMT_ADDR=${MGMT_ADDR}"
    echo "JBOSS_CLI=${MGMT_ADDR}:${CLI_PORT}"
    #echo "JBOSS_OPTS=${JBOSS_OPTS}"
    #echo "JAVA_OPTS=${JAVA_OPTS}"
    echo "================================================================================"
fi
#============================================================================================[E]#



#[S] Checking JBoss ============================================================================#
### Process Check
PID=`ps -ef | grep java | grep -v grep | grep "=${SERVER_NAME} " | awk '{print $2}'`
if [ "e${PID}" != "e" ] && [ "e${1}" == "eSTART" ];
then
    echo "JBoss SERVER - [PID:${PID}] ${SERVER_NAME} is already RUNNING..."
    exit;
fi

### User Check
UNAME=`whoami`
if [ "e${UNAME}" != "e${JBOSS_USER}" ];
then
    echo "Use ${JBOSS_USER} account to start JBoss SERVER - ${SERVER_NAME}..."
    exit;
fi


### Create Directory
if [ ! -d "$JBOSS_LOG_HOME/nohup" ];
then
    mkdir -p $JBOSS_LOG_HOME/nohup
fi

if [ ! -d "$JBOSS_LOG_HOME/gclog" ];
then
    mkdir -p $JBOSS_LOG_HOME/gclog
fi

if [ ! -d "$JBOSS_LOG_HOME/dump" ];
then
    mkdir -p $JBOSS_LOG_HOME/dump
fi
#============================================================================================[E]#



#[S] Rotate Log ================================================================================#
DATETIME=`date +%Y%m%d%H%M%S`
### Move Log File
if [ "e${1}" == "eSTART" ] || [ "e${1}" == "eSHUTDOWN" ] || [ "e${1}" == "eKILL" ];
then
    if [ -f "${JBOSS_LOG_HOME}/nohup/${SERVER_NAME}.out" ];
    then
        mv ${JBOSS_LOG_HOME}/nohup/${SERVER_NAME}.out ${JBOSS_LOG_HOME}/nohup/[${1}]${SERVER_NAME}.out.${DATETIME}
    fi
    if [ -f "${JBOSS_LOG_HOME}/gclog/gc_${SERVER_NAME}.log" ];
    then
        mv ${JBOSS_LOG_HOME}/gclog/gc_${SERVER_NAME}.log ${JBOSS_LOG_HOME}/gclog/[${1}]gc_${SERVER_NAME}.log.${DATETIME}
    fi
fi
#============================================================================================[E]#



# EOF ========== EOF ========== EOF ========== EOF ========== EOF ========== EOF ========== EOF #
