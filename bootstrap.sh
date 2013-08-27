#!/bin/bash

set -e

apt-get update
apt-get install -y git curl postgresql libpq-dev

curl -L https://get.rvm.io | sudo -u vagrant HOME=/home/vagrant bash -s stable
echo 'source ~vagrant/.rvm/scripts/rvm && rvm use --install --default 1.9.3' | sudo -u vagrant bash
echo 'source ~/.rvm/scripts/rvm' >> ~vagrant/.bashrc
echo 'rvm use 1.9.3' >> ~vagrant/.bashrc

sudo -u postgres psql postgres -c 'create role vagrant with login createdb'
sudo -u postgres psql postgres -c 'create database green_mercury owner vagrant'
sudo -u postgres psql postgres -c 'create database green_mercury_test owner vagrant'
sed -i 's/md5/trust/' /etc/postgresql/9.1/main/pg_hba.conf
service postgresql restart

ln -s /vagrant ~vagrant/green_mercury

cd ~vagrant/green_mercury
	echo 'source ~vagrant/.rvm/scripts/rvm && bundle install' | sudo -u vagrant bash
cd -
