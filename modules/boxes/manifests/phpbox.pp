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

  php::runtime {"5.4.2":
    version => "5.4.2"
  }
  
  Php::Extension <| |> -> Php::Runtime["5.4.2"]
}