# puppet manifests for a heroku-like box

class boxes::heroku {
  include puppet
  include rvm
  include rubies::dependencies::mri
  
  # heroku runs postgres 8.3, but there are no postgres-8.3 packages for lucid
  package {"postgresql-8.4":
    ensure => present,
    alias  => "postgresql-server" 
  }
  
  service {"postgresql-8.4":
    ensure => running,
    enable => true,
    require => Package["postgresql-server"],
    alias => "postgresql-server"
  }

  package {"libpq-dev":
    ensure => present
  }

  rvm::define::version { "ruby-1.9.2":
    ensure => 'present',
    default_ruby => 'true',
    require => Class["rubies::dependencies::mri"]
  }

  rvm::define::gem { ['bundler', 'pry', 'yard', 'foreman']:
    ensure       => 'present',
    ruby_version => 'ruby-1.9.2',
  }

}
