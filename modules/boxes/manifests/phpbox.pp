class boxes::phpbox {
  include puppet
  include php

  php::extension {"mcrypt":
    flag => "--with-mcrypt",
    packages => ["libmcrypt-dev"]
  }

  php::extension {"readline":
    flag => "--with-readline",
    packages => ["libreadline-dev"]
  }

  class {"php::runtime":
    version => "5.4.2"
  }
  
  Php::Extension["mcrypt"] -> Php::Extension["readline"] -> Class["php::runtime"]
}