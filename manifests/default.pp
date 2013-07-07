$home = '/home/vagrant'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

# -

include apt
include redis
include mysql

node default {
  class { 'nginx': }
}

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
  content => "Welcome to your Vagrant-built virtual machine for Rails development!
  Managed by Puppet."
}

stage { 'preinstall':
  before => Stage['main']
}

package { ['curl', 'zlib1g-dev', 'git-core', 'libsqlite3-dev']:
  ensure => installed
} ->

package { ['python-software-properties', 'software-properties-common']:
  ensure => installed
} ->

# Nokogiri dependencies
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
} ->

# ExecJS runtime.
package { 'nodejs':
  ensure => installed
} ->

exec { "install_ruby_build":
  command => "git clone https://github.com/sstephenson/ruby-build.git && cd ruby-build && sudo ./install.sh",
  cwd => $home,
  creates => "/usr/local/bin/ruby-build",
  path => "/usr/bin/:/bin/",
  logoutput => true,
} ->
exec { "install_ruby":
  command => "ruby-build 2.0.0-p247 /home/vagrant/.rubies/ruby-2.0.0-p247",
  cwd => $home,
  creates => "/home/vagrant/.rubies/ruby-2.0.0-p247",
  timeout => 600,
  path => "/usr/local/bin:/usr/bin/:/bin/",
  logoutput => true,
} ->
exec { "install_chruby":
  command => "wget -O chruby-0.3.4.tar.gz https://github.com/postmodern/chruby/archive/v0.3.4.tar.gz && tar -xzvf chruby-0.3.4.tar.gz && cd chruby-0.3.4/ && sudo make install",
  cwd => $home,
  creates => '/usr/local/bin/chruby-exec',
  path => "/usr/local/bin:/usr/bin/:/bin/",
  logoutput => true,
} ->
file { '/etc/profile.d/chruby.sh':
  content => '[ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || return
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh'
} ->
file_line { "default_chruby":
  line => "chruby ruby-2.0.0-p247",
  path => '/home/vagrant/.bashrc'
} ->
exec { "install_godeb":
  command => "wget -O godeb-386.tar.gz https://godeb.s3.amazonaws.com/godeb-386.tar.gz && tar -xzvf godeb-386.tar.gz && sudo ./godeb install",
  logoutput => true
}

