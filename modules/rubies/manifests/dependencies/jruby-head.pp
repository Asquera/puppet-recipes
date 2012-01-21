
class rubies::dependencies::jruby-head {
	
	package{ ['curl', 'g++', 'openjdk-6-jre-headless', 'openjdk-6-jdk', 'ant']:
	  ensure => present
  }
	
}