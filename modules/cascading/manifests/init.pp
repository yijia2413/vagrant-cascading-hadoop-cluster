class cascading{
  exec { "download_sdk":
    command => "wget -P /tmp -i http://files.concurrentinc.com/sdk/2.2/latest.txt",
    path => $path,
    unless => "ls /opt | grep CascadingSDK",
    require => Package["openjdk-6-jdk"]
  }

  exec { "unpack_sdk" :
    command => "tar xf /tmp/Cascading-*tgz -C /opt && mv /opt/Cascading*SDK* /opt/CascadingSDK",
    path => $path,
    unless => "ls /opt | grep CascadingSDK",
    require => Exec["download_sdk"]
  }

  file { "/etc/profile.d/ccsdk.sh":
    source => "puppet:///modules/cascading/ccsdk.sh",
    owner => root,
    group => root,
  }
}
