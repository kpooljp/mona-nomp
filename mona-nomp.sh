#!/bin/sh

KNOMP_DIR=/usr/local/mona-nomp
PIDFILE="/var/lock/subsys/mona-nomp"

TIMESTAMP=`date`

case "$1" in
start)
  if [ -f  ${PIDFILE} ]; then
    echo "${TIMESTAMP} : mona-nomp is already running"
    exit 1
  fi
  echo "${TIMESTAMP} : Starting mona-nomp"
  cd ${KNOMP_DIR}
  /usr/local/bin/npm start > /var/log/k-nomp.log 2>&1 &
  echo $! > ${PIDFILE}
;;

stop)
  if [ ! -f  ${PIDFILE} ]; then
    echo "${TIMESTAMP} : mona-nomp is not running"
    exit 1
  fi
  PID=`cat ${PIDFILE}`
  PID=`ps -h --ppid ${PID} | awk '{print $1}'`
  PID=`ps -h --ppid ${PID} | awk '{print $1}'`
  RET=`kill ${PID}`

  echo "${TIMESTAMP} : Stopping mona-nomp"

  rm ${PIDFILE}
;;

restart)
  $0 stop
  sleep 10
  $0 start
;;

*)
  echo "${TIMESTAMP} : Using mona-nomp.sh stop | start | restart"
  exit 1

;;

esac

