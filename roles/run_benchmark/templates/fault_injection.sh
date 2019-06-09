{% raw %}
#!/bin/bash

FAULT_DURATION=( $1 )
FAULT_INTERVAL=( $2 )

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
    echo sleeping ${FAULT_DURATION}s before starting ${SERVICE} again on ${IP}...
    sleep ${FAULT_DURATION};
    ssh ${USER}@${IP} 'sudo service '${SERVICE}' start'
    echo service ${SERVICE} started
    echo sleeping ${FAULT_INTERVAL}s before next fault...
    sleep ${FAULT_INTERVAL}
    echo
done
{% endraw %}
