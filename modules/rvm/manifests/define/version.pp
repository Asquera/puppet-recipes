define rvm::define::version (
  $ensure = 'present',
  $default_ruby = 'false'
) {
  include rvm
  include rvm::helpers

  ## Set sensible defaults for Exec resource
  Exec {
    environment => "HOME=/home/vagrant",
    path    => '/usr/local/rvm/bin:/bin:/sbin:/usr/bin:/usr/sbin:/home/vagrant/.rvm/bin/',
    cwd     => '/home/vagrant',
    user    => vagrant
  }

  # Install or uninstall RVM Ruby Version
  if $ensure == 'present' {
    exec { "install-ruby-${name}":
      command => "rvm install ${name} 2>&1",
      unless  => "rvm list | grep ${name}",
      timeout => '0',
      require => Class['rvm'],
    }
  } elsif $ensure == 'absent' {
    exec { "uninstall-ruby-${name}":
      command => "rvm uninstall ${name}",
      onlyif  => "rvm list | grep ${name}",
      require => Class['rvm'],
    }
  }

  # Establish Default Ruby.
  # Only create one instance to prevent multiple ruby
  # versions from attempting to be system default.
  if ($default_ruby == 'true') and ($ensure != 'absent') {

    file { "/tmp/set-default-ruby.sh":
      ensure => present,
      content => template('rvm/set-default-ruby.sh.erb'),
      mode => '0755',
    }

    exec { "set-default-ruby-$name.sh":
      command => "/tmp/set-default-ruby.sh ${name}",
      unless  => "rvm list | grep '* ${name}'",
      require => [Class['rvm'], Exec["install-ruby-${name}"], File['/tmp/set-default-ruby.sh']],
      notify  => Exec['rvm-cleanup'],
      user    => "vagrant",
      environment  => "HOME=/home/vagrant",
    }

    #file { "cleanup-rvm-set-script":
    #  path   => "/tmp/set-default-ruby.sh",
    #  ensure => absent,
    #  require => Exec["set-default-ruby-$name.sh"],
    #}

  }
}
