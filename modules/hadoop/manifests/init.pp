class hadoop {
  $hadoop_version = "1.2.1"
  $hadoop_home = "/opt/hadoop-${hadoop_version}"

  file { ["/srv/hadoop/",  "/srv/hadoop/namenode", "/srv/hadoop/datanode/"]:
    ensure => "directory"
  }

  exec { "download_grrr":
    command => "wget --no-check-certificate http://raw.github.com/fs111/grrrr/master/grrr -O /tmp/grrr && chmod +x /tmp/grrr",
    path => $path,
    creates => "/tmp/grrr",
  }

  exec { "download_hadoop":
    command => "/tmp/grrr /hadoop/common/hadoop-${hadoop_version}/hadoop-$hadoop_version.tar.gz -O /vagrant/hadoop.tar.gz --read-timeout=5 --tries=0",
    timeout => 1800,
    path => $path,
    unless => "ls /vagrant | grep hadoop.tar.gz",
    require => [ Package["openjdk-6-jdk"], Exec["download_grrr"]]
  }

  exec { "unpack_hadoop" :
    command => "tar xf /vagrant/hadoop.tar.gz -C /opt",
    path => $path,
    creates => "${hadoop_home}",
    require => Exec["download_hadoop"]
  }

  file {
    "${hadoop_home}/conf/slaves":
      source => "puppet:///modules/hadoop/slaves",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"]
  }

  file {
    "${hadoop_home}/conf/masters":
      source => "puppet:///modules/hadoop/masters",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"]
  }

  file {
    "${hadoop_home}/conf/core-site.xml":
      source => "puppet:///modules/hadoop/core-site.xml",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"]
  }

  file {
    "${hadoop_home}/conf/mapred-site.xml":
      source => "puppet:///modules/hadoop/mapred-site.xml",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"]
  }

  file {
    "${hadoop_home}/conf/hdfs-site.xml":
      source => "puppet:///modules/hadoop/hdfs-site.xml",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"]
  }

  file {
    "${hadoop_home}/conf/hadoop-env.sh":
      source => "puppet:///modules/hadoop/hadoop-env.sh",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"]
  }

  file { "/etc/profile.d/hadoop-path.sh":
    content => template("hadoop/hadoop-path.sh.erb"),
    owner => root,
    group => root,
  }

}
