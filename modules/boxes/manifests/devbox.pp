class boxes::devbox {
	Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/home/vagrant/.rvm/bin" ] }
	
	include puppet
	include rvm
	include rubies::dependencies::mri

	
	rvm::define::version { "ruby-1.9.3":
	  ensure => 'present',
    require => Class["rubies::dependencies::mri"]
	}
	
	rvm::define::version { "ruby-1.9.2":
	  ensure => 'present',
    default_ruby => 'true',
    require => Class["rubies::dependencies::mri"]
	}
	
	rvm::define::gem { ['bundler', 'pry', 'yard', 'foreman']:
	  ensure       => 'present',
	  ruby_version => 'ruby-1.9.3',
	}

}