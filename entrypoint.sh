#!/bin/bash

set -e

echo "Update /etc/hosts"
cat << EOF >> /etc/hosts
192.0.2.1 cluster
192.0.2.10 node1
192.0.2.11 node2
192.0.2.12 node3
192.0.2.13 node4
192.0.2.14 node5
192.0.2.100 instance1
192.0.2.101 instance2
192.0.2.102 instance3
192.0.2.103 instance4
192.0.2.104 instance5
192.0.2.105 instance6
192.0.2.106 instance7
192.0.2.107 instance8
192.0.2.108 instance9
192.0.2.109 instance10
EOF

echo "Setup interfaces"
ip link add gnt type dummy
ip link set dev gnt up

echo "Init Cluster"
mkdir /opt/ganeti-vcluster
cd /usr/lib/ganeti/tools/
./vcluster-setup -E -c 5 -n gnt /opt/ganeti-vcluster
cd /opt/ganeti-vcluster && node1/cmd gnt-cluster init --no-etc-hosts \
    --no-ssh-init --master-netdev=lo \
    --enabled-disk-templates=diskless --enabled-hypervisors=fake \
    --ipolicy-bounds-specs=min:disk-size=0,cpu-count=1,disk-count=0,memory-size=1,nic-count=0,spindle-use=0/max:disk-size=1048576,cpu-count=8,disk-count=16,memory-size=32768,nic-count=8,spindle-use=12 \
    cluster

chown root:root /opt/ganeti-vcluster/node1/var/run/ganeti/*.pid

echo "Start Cluster"
./start-all

echo "Generate SSH Key"
ssh-keygen -f /root/.ssh/id_rsa -N ""
cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
service ssh start
ssh-keyscan cluster >> /root/.ssh/known_hosts

echo "Add four more nodes to the cluster..."
./node1/cmd gnt-node add --no-ssh-key-check node2
./node1/cmd gnt-node add --no-ssh-key-check node3
./node1/cmd gnt-node add --no-ssh-key-check node4
./node1/cmd gnt-node add --no-ssh-key-check node5

# add fake instances
echo "Create a bunch of instances..."
./node1/cmd gnt-instance add -t diskless --no-ip-check --no-name-check --no-install -o noop --no-nics homer
./node1/cmd gnt-instance add -t diskless --no-ip-check --no-name-check --no-install -o noop --no-nics bart
./node1/cmd gnt-instance add -t diskless --no-ip-check --no-name-check --no-install -o noop --no-nics marge
./node1/cmd gnt-instance add -t diskless --no-ip-check --no-name-check --no-install -o noop --no-nics lisa
./node1/cmd gnt-instance add -t diskless --no-ip-check --no-name-check --no-install -o noop --no-nics burns
./node1/cmd gnt-instance add -t diskless --no-ip-check --no-name-check --no-install -o noop --no-nics milhouse
./node1/cmd gnt-instance add -t diskless --no-ip-check --no-name-check --no-install -o noop --no-nics moe
./node1/cmd gnt-instance add -t diskless --no-ip-check --no-name-check --no-install -o noop --no-nics smithers

echo "Restart RAPI"
pkill ganeti-rapi
export GANETI_ROOTDIR=/opt/ganeti-vcluster//node1
export HOME=/var/lib/ganeti
export GANETI_HOSTNAME=node1
echo "gnt-cc {HA1}2ac2878ee230f34cd08e5f95ccc0e664 write" > /opt/ganeti-vcluster/node1/var/lib/ganeti/rapi/users

echo
echo "You can now access the RAPI at https://gnt-cc:gnt-cc@${HOSTNAME}:5080/"
echo

exec $@
