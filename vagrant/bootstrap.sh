#!/bin/bash

set -e

apt-get update
apt-get install -y git curl postgresql libpq-dev dbus-x11 firefox xvfb

curl -L https://get.rvm.io | sudo -u vagrant HOME=/home/vagrant bash -s stable
echo 'source ~vagrant/.rvm/scripts/rvm && rvm use --install --default 1.9.3' | sudo -u vagrant bash
echo 'source ~/.rvm/scripts/rvm' >> ~vagrant/.bash_profile
echo 'rvm use 1.9.3' >> ~vagrant/.bash_profile

sudo -u postgres psql postgres -c "create role vagrant with login createdb password 'hacktehplanit'"
sudo -u postgres psql postgres -c 'create database green_mercury owner vagrant'
sudo -u postgres psql postgres -c 'create database green_mercury_test owner vagrant'
service postgresql restart

ln -s /vagrant ~vagrant/green_mercury

cd ~vagrant/green_mercury
	echo 'source ~vagrant/.rvm/scripts/rvm && bundle install' | sudo -u vagrant bash
cd -

echo 'export DISPLAY=:99' >> ~vagrant/.bash_profile
cp /vagrant/vagrant/xvfb.init-script /etc/init.d/xvfb
chmod 755 /etc/init.d/xvfb
service xvfb start
