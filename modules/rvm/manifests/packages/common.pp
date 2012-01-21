class rvm::packages::common {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/rvm/bin:/home/vagrant/.rvm/bin/',
    user => vagrant,
    cwd => '/home/vagrant'
  }

  exec { 'download-rvm-install':
    command => 'wget -O /tmp/rvm https://rvm.beginrescueend.com/install/rvm',
    creates => '/tmp/rvm',
    unless  => 'which rvm',
  }
  exec { 'install-rvm':
    environment => "HOME=/home/vagrant",
    command => "bash /tmp/rvm 2>&1",
    creates => '/home/vagrant/.rvm/bin/rvm',
    require => Exec['download-rvm-install'],
    logoutput => true
  }

  file { '/tmp/rvm':
    ensure  => absent,
    require => Exec['install-rvm'],
  }
}