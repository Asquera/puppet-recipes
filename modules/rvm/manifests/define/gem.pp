# Compliments of Toni Leino (Frodotus)
# # https://github.com/Frodotus/puppet-rvm/commit/17d854f20f0d49185938f84c4108823e9212c02a
define rvm::define::gem(
  $ensure = 'present',
  $ruby_version,
  $gemset = '',
  $gem_version = ''
) {  
  ## Set sensible defaults for Exec resource
  Exec {
    path    => '/usr/local/rvm/bin:/bin:/sbin:/usr/bin:/usr/sbin:/home/vagrant/.rvm/bin/',
    user    => vagrant,
    environment => "HOME=/home/vagrant",
  }
  
  # Local Parameters
  $rvm_path = '/usr/local/rvm'
  $rvm_ruby = "${rvm_path}/rubies"
  
  if $gemset == '' {
    $rvm_depency = "install-ruby-${ruby_version}"        
  } else {
    $rvm_depency = "rvm-gemset-create-${gemset}-${ruby_version}"        
    $rubyset_version = "${ruby_version}@${gemset}"
  }
  # Setup proper install/uninstall commands based on gem version.
  if $gem_version == '' {
    $gem = {
      'install'   => "/home/vagrant/.rvm/bin/rvm-shell ${ruby_version} -c 'gem install ${name} --no-ri --no-rdoc'",
      'uninstall' => "/home/vagrant/.rvm/bin/rvm-shell ${ruby_version} -c 'gem uninstall ${name}'",
      'lookup'    => "/home/vagrant/.rvm/bin/rvm-shell ${ruby_version} -c 'gem list | grep ${name}'",
    }
  } else {
    $gem = {
      'install'   => "/home/vagrant/.rvm/bin/rvm-shell ${ruby_version} -c 'gem install ${name} -v ${gem_version} --no-ri --no-rdoc'",
      'uninstall' => "/home/vagrant/.rvm/bin/rvm-shell ${ruby_version} -c 'gem uninstall ${name} -v ${gem_version}'",
      'lookup'    => "/home/vagrant/.rvm/bin/rvm-shell ${ruby_version} -c 'gem list | grep ${name} | grep ${gem_version}'",
    }
  }

  
  ## Begin Logic
  if $ensure == 'present' {
    exec { "rvm-gem-install-${name}-${ruby_version}":
      command => $gem['install'],
      unless  => $gem['lookup'],
      require => [Class['rvm'], Exec[$rvm_depency]],
      logoutput => true
    }
  } elsif $ensure == 'absent' {
    exec { "rvm-gem-uninstall-${name}-${version}":
      command => $gem['uninstall'],
      onlyif  => $gem['lookup'],
      require => [Class['rvm'], Exec[$rvm_depency]],
    }    
  }
}
