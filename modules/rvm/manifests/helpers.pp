class rvm::helpers {
  exec { 'rvm-cleanup':
    command     => '/home/vagrant/.rvm/bin/rvm cleanup sources',
    refreshonly => 'true',
  }

  exec { 'upgrade-rvm':
    command     => '/home/vagrant/.rvm/bin/rvm update ; /home/vagrant/.rvm/bin/rvm reload',
    refreshonly => 'true',
  }
}
