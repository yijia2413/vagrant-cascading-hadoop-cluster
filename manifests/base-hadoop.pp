include hadoop
group { "puppet":
  ensure => "present",
}
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
}

package { "openjdk-6-jdk" :
   ensure => present,
  require => Exec['apt-get update']
}

file { "/root/.ssh":
    ensure => "directory",
}


file { 
  "/root/.ssh/config":
  source => "puppet:///modules/hadoop/ssh_config",
  mode => 600,
  owner => root,
  group => root,
  require => Exec['apt-get update']
}

file {
  "/root/.ssh/id_rsa":
  source => "puppet:///modules/hadoop/id_rsa",
  mode => 600,
  owner => root,
  group => root,
  require => Exec['apt-get update']
 }
 
file {
  "/root/.ssh/id_rsa.pub":
  source => "puppet:///modules/hadoop/id_rsa.pub",
  mode => 644,
  owner => root,
  group => root,
  require => Exec['apt-get update']
 }

ssh_authorized_key { "ssh_key":
    ensure => "present",
    key    => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCeHdBPVGuSPVOO+n94j/Y5f8VKGIAzjaDe30hu9BPetA+CGFpszw4nDkhyRtW5J9zhGKuzmcCqITTuM6BGpHax9ZKP7lRRjG8Lh380sCGA/691EjSVmR8krLvGZIQxeyHKpDBLEmcpJBB5yoSyuFpK+4RhmJLf7ImZA7mtxhgdPGhe6crUYRbLukNgv61utB/hbre9tgNX2giEurBsj9CI5yhPPNgq6iP8ZBOyCXgUNf37bAe7AjQUMV5G6JMZ1clEeNPN+Uy5Yrfojrx3wHfG40NuxuMrFIQo5qCYa3q9/SVOxsJILWt+hZ2bbxdGcQOd9AXYFNNowPayY0BdAkSr",
    type   => "ssh-rsa",
    user   => "root",
    require => File['/root/.ssh/id_rsa.pub']
}

exec { 'hadoop_in_path':
    command => '/bin/echo \'export PATH=$PATH:/opt/hadoop-1.1.2/bin\' >> /etc/bash.bashrc '
}

package { "avahi-daemon":
      ensure => "installed",
      require => Exec['apt-get update']
}

file { "/etc/avahi/avahi-daemon.conf":
  source => "puppet:///modules/hadoop/avahi-daemon.conf",
  owner => root,
  group => root,
  notify  => Service["avahi-daemon"],
  require => Package["avahi-daemon"]
}


service{ "avahi-daemon":
      ensure     => "running",
      enable => true,
      require =>  File['/etc/avahi/avahi-daemon.conf']
}

file{ "/etc/hosts":
   source => "puppet:///modules/hadoop/hosts",
   owner => root,
   group => root,
}

file{ "/etc/avahi/hosts":
   source => "puppet:///modules/hadoop/hosts",
   owner => root,
   group => root,
   notify => Service["avahi-daemon"]
}
