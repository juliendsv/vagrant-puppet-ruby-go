# Vagrant + Puppet + Ruby + Go
This is a Vagrant configuration automating the setup of a dev environment for Ruby and Go apps.
It use Ubuntu 13.04 (Raring), here what it contains:

* Ruby 2.0.0-p247 
* Go 1.1 (using godeb see <http://blog.labix.org/2013/06/15/in-flight-deb-packages-of-go>)
* Nginx
* Mysql
* Redis

# Usage
I assume you already have VirtualBox and Vagrant installed

Install Puppet :

```
$ gem install puppet
```
Install librarian-puppet

```
$ gem install librarian-puppet
```

Clone this repository

```
$ git clone https://github.com/juliendsv/vagrant-puppet-ruby-go.git 
$ cd vagrant-puppet-ruby-go
```

Get the module first 

```
$ librarian-puppet install
```

Boot the virtual machine, provision will be done automatically 

```
$ vagrant up
```

Enjoy.
