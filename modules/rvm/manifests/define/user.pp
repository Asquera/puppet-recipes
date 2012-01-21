define rvm::define::user() {
  exec { "/usr/sbin/usermod -a -G rvm ${name}":
      path    => '/bin:/sbin:/usr/bin:/usr/sbin:/home/vagrant/.rvm/bin/',
      unless  => "cat /etc/group | grep $group | grep $username",
      require => [User[$name], Class['rvm']],
  }
}