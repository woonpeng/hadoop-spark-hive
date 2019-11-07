# docker exec hive-db cp /usr/share/java/mysql-connector-java.jar /usr/local/hive/lib
winpty docker exec -it hive-db bash -c "cp /usr/share/java/mysql-connector-java.jar /usr/local/hive/lib"
# setup hive database in mysql
winpty docker exec -it hive-db bash -c "su root -c 'chown -R mysql:mysql /var/lib/mysql'"

winpty docker exec -it hive-db bash -c "su root -c 'service mysql start'"

winpty docker exec -it hive-db bash -c "su root -c 'mysql -uroot -proot -e \"source /usr/local/setup_script.sql\"'"
winpty docker exec -it hive-db bash -c "su root -c 'rm -f /usr/local/setup_script.sql'"

# create hive database directories
winpty docker exec hive-db hadoop/bin/hdfs dfs -mkdir user
winpty docker exec hive-db hadoop/bin/hdfs dfs -mkdir user/hive
winpty docker exec hive-db hadoop/bin/hdfs dfs -mkdir user/hive/warehouse
winpty docker exec hive-db hadoop/bin/hdfs dfs -mkdir tmp
winpty docker exec hive-db hadoop/bin/hdfs dfs -chmod -R a+rwx user/hive/warehouse
winpty docker exec hive-db hadoop/bin/hdfs dfs -chmod g+w tmp

winpty docker exec -d hive-db hive --service metastore &
