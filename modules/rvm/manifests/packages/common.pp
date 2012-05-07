class rvm::packages::common($user = "vagrant", $passedhome = "") {
  if ("" == $passedhome) {
    $home = "/home/$user"
  } else {
    $home = $passedhome
  }

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/rvm/bin:/home/vagrant/.rvm/bin/',
    user => $user,
    cwd => $home
  }

  exec { 'download-rvm-install':
    command => 'wget -O /tmp/rvm https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer',
    creates => '/tmp/rvm',
    unless  => 'which rvm',
  }
  exec { 'install-rvm':
    environment => "HOME=$home",
    command => "bash /tmp/rvm stable 2>&1",
    creates => "$home/.rvm/bin/rvm",
    require => Exec['download-rvm-install'],
    logoutput => true
  }

  file { '/tmp/rvm':
    ensure  => absent,
    require => Exec['install-rvm'],
  }
}