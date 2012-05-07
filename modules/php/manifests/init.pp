class php {
  $configure_flags = ""
  
  define download(
        $site="",
        $cwd="",
        $creates="",
        $user="") {                                                                                         

    exec { $name:                                                                                                                    
        command => "/usr/bin/wget --content-disposition ${site}/${name}",                                                         
        cwd => $cwd,
        creates => "${cwd}/${creates}",                                                              
        user => $user,                                                                                                        
    }
  }

  define extension($flag, $packages = []) {
    $php::configure_flags += " $flag"

    package { $packages:
      ensure => present
    }
  }

  define runtime($version) {
    Exec { path => ["/bin", "/usr/bin", "/tmp/php-$version"]}

    package {["php5-dev", "libxml2-dev"]:
      ensure => present
    }

    download{ "get/php-$version.tar.bz2/from/this/mirror":
      creates => "php-$version.tar.bz2",
      site => "http://de.php.net",
      cwd => "/tmp",
      user => "vagrant"
    }

    exec { "unpack":
      command => "tar -xvf php-$version.tar.bz2",
      cwd => "/tmp/"
    }

    exec { "configure": 
      command => "./configure ${php::configure_flags}",
      cwd => "/tmp/php-$version/"
    }

    exec { "make": 
      command => "make",
      cwd => "/tmp/php-$version/"
    }

    exec { "make_install":
      command => "make install",
      cwd => "/tmp/php-$version/"
    }

    Package["php5-dev"] -> Package["libxml2-dev"] -> Download["get/php-$version.tar.bz2/from/this/mirror"] -> 
    Exec["unpack"] -> Exec["configure"] -> Exec["make"] -> Exec["make_install"]
  }
}