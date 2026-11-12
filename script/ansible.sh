#!/usr/bin/env bash

set -xeu
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y ansible ansible-lint whois curl

mkdir -p ./private_keys
cp -vf /vagrant/.vagrant/machines/dns/virtualbox/private_key ./private_keys/dns.key.rsa
cp -vf /vagrant/.vagrant/machines/negocio/virtualbox/private_key ./private_keys/negocio.key.rsa
chown vagrant:vagrant ./private_keys/*
chmod 600 ./private_keys/*

cp -vrf /vagrant/dns .
chown -R vagrant:vagrant ./dns

cp -vf /vagrant/ansible.cfg .
cp -vf /vagrant/inventory.yml .
cp -vf /vagrant/requirements.yml .
chown vagrant:vagrant ./ansible.cfg ./inventory.yml

cp -vrf /vagrant/dns .
chown -R vagrant:vagrant ./dns

cp -vrf /vagrant/web .
chown -R vagrant:vagrant ./web

cp -vrf /vagrant/ftp .
chown -R vagrant:vagrant ./ftp

cp -vf /vagrant/vault_pass.txt ./.vault_pass.txt
chmod 600 ./.vault_pass.txt