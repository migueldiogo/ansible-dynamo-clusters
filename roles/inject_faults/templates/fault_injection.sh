{% raw %}
#!/bin/bash

FAULT_DURATION_MAX=( $1 )
FAULT_INTERVAL_MAX=( $2 )

SERVICE=( $3 )

USER=( $4 )
{% endraw %}

IPS=( {% for host in groups['nodes'] -%}
 {{ hostvars[host]['ansible_host']}}{% if not loop.last %} {% endif %}
{%- endfor %} )

{% raw %}
while true
do
    RANDOM=$$$(date +%s)
    IP=${IPS[$RANDOM % ${#IPS[@]}]}
    echo initiating service fault on ${IP}
    ssh ${USER}@${IP} 'sudo service '${SERVICE}' stop'
    echo service ${SERVICE} stopped on ${IP}
    RANDOM_FAULT_DURATION=$(( ( RANDOM % ${FAULT_DURATION_MAX} )  + 1 ))
    echo sleeping ${RANDOM_FAULT_DURATION}s before starting ${SERVICE} again on ${IP}...
    sleep ${RANDOM_FAULT_DURATION}
    ssh ${USER}@${IP} 'sudo service '${SERVICE}' start'
    echo service ${SERVICE} started
    RANDOM_FAULT_INTERVAL=$(( ( RANDOM % ${FAULT_INTERVAL_MAX} )  + 1 ))
    echo sleeping ${RANDOM_FAULT_INTERVAL}s before next fault...
    sleep ${RANDOM_FAULT_INTERVAL}
    echo
done
{% endraw %}
