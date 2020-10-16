#!/bin/bash

cleanup() {
    echo "Stopping Cluster..."
    /opt/ganeti-vcluster/stop-all
}

trap 'true' SIGTERM

su --preserve-environment -s /bin/bash -c '/usr/bin/python /usr/sbin/ganeti-rapi --debug -b 0.0.0.0 -f' gnt-rapi &

wait $!

cleanup
