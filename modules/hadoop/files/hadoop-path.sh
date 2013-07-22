# used by most Hadoop tools even though bin/hadoop warns against it
export HADOOP_PREFIX=/opt/hadoop-1.1.2
export HADOOP_CONF_DIR=$HADOOP_PREFIX/conf
export PATH=$HADOOP_PREFIX/bin:$PATH
