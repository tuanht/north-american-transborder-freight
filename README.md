# Introduction
# Installation
Only tested on Ubuntu.
## Prerequisite
1. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Vagrant](http://www.vagrantup.com/downloads.html)
## Install Vagrant plugins:
```
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-librarian-chef-nochef
```
## Clone or download this repo
```
git git@github.com:tuanht/north-american-transborder-freight.git
```
or
```
wget https://github.com/tuanht/north-american-transborder-freight.git
```
## Start Vagrant box
```
vagrant up
```
and wait until the box booted successfully!
## Connect to Vagrant box
```
vagrant ssh
```
## Install require gems
```
bin/bundle install
rbenv rehash
```
## Setup database
```
rake db:create
rake db:migrate
```
## Start web server (Puma)
```
rails server -b 0.0.0.0
```
# Import sample data
You can import all sample data with one command
```
rake codes:import
rake data:import
```
## You've done and now you can browse [http://localhost:3000](http://localhost:3000).
![Alt text](/path/to/img.jpg)