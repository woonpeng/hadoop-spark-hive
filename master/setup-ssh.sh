#!/bin/sh
echo "creating ssh key for hadoop-master"
winpty docker exec -it hadoop-master bash -c "ssh-keygen -t rsa -b 4096 -f /home/hadoop/.ssh/id_rsa"
echo "change owner for hadoop-master"
winpty docker exec hadoop-master bash -c 'cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys'
winpty docker exec hadoop-master bash -c 'chmod og-wx ~/.ssh/authorized_keys'
winpty docker exec -it hadoop-master bash -c "su root -c 'service ssh restart'"
# winpty docker exec hadoop-master bash -c 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no localhost'
winpty docker exec -it hadoop-slave1 bash -c "su root -c 'service ssh restart'"
winpty docker exec -it hadoop-slave2 bash -c "su root -c 'service ssh restart'"
winpty docker exec -it hadoop-master bash -c "ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@hadoop-slave1"
winpty docker exec -it hadoop-master bash -c "ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@hadoop-slave2"
winpty docker exec -it hadoop-slave1 bash -c "su root -c 'service ssh restart'"
winpty docker exec -it hadoop-slave2 bash -c "su root -c 'service ssh restart'"
winpty docker exec -it hive-db bash -c "su root -c 'service ssh restart'"



# echo "creating ssh key for hadoop-master"
# winpty docker exec -it hadoop-master ssh-keygen -t rsa -b 4096
# echo "moving ssh key for hadoop-master"
# winpty docker exec hadoop-master bash -c 'cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys'
# echo "change owner for hadoop-master"
# winpty docker exec hadoop-master bash -c 'chmod og-wx ~/.ssh/authorized_keys'
# winpty docker exec -it hadoop-master bash -c "su root -c 'service ssh restart'"
# # winpty docker exec hadoop-master bash -c 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no localhost'
# winpty docker exec -it hadoop-slave1 bash -c "su root -c 'service ssh restart'"
# winpty docker exec -it hadoop-slave2 bash -c "su root -c 'service ssh restart'"
# winpty docker exec -it hadoop-master bash -c "ssh-copy-id -i ~/.ssh/id_rsa.pub root@hadoop-slave1"
# winpty docker exec -it hadoop-master bash -c "ssh-copy-id -i ~/.ssh/id_rsa.pub root@hadoop-slave2"
# winpty docker exec -it hadoop-slave1 bash -c "su root -c 'service ssh restart'"
# winpty docker exec -it hadoop-slave2 bash -c "su root -c 'service ssh restart'"

winpty docker exec -it hadoop-master bash -c "su root -c 'service ssh restart'"
winpty docker exec hadoop-master /usr/local/hadoop/bin/hdfs namenode -format
winpty docker exec -it hadoop-master /usr/local/hadoop/sbin/start-all.sh

winpty docker exec -it hadoop-master jupyter notebook --ip=0.0.0.0 --port=8081
