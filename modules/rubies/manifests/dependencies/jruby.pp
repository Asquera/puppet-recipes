
class rubies::dependencies::jruby {
	
	package{ ['curl', 'g++', 'openjdk-6-jre-headless']:
	  ensure => present
  }
	
}