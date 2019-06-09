
#!/bin/bash

FAULT_DURATION=( $1 )
FAULT_INTERVAL=( $2 )

SERVICE=( $3 )

USER=( $4 )

IPS=( 34.246.223.113 52.19.235.241 34.244.208.129 18.202.241.218 52.208.44.6 )


while true
do
    RANDOM=$$$(date +%s)
    IP=${IPS[$RANDOM % ${#IPS[@]}]}
    echo initiating service fault on ${IP}
    ssh ${USER}@${IP} 'sudo service '${SERVICE}' stop'
    echo service ${SERVICE} stopped on ${IP}
    echo sleeping ${FAULT_DURATION}s before starting ${SERVICE} again on ${IP}...
    sleep ${FAULT_DURATION};
    ssh ${USER}@${IP} 'sudo service '${SERVICE}' start'
    echo service ${SERVICE} started
    echo sleeping ${FAULT_INTERVAL}s before next fault...
    sleep ${FAULT_INTERVAL}
    echo
done
