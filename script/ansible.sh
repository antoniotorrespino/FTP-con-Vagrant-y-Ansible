#!/usr/bin/env bash
#
# Configura el servidor como un nodo de control de Ansible
#
set -xeu

# Instalar ansible
apt-get update
apt-get install -y ansible ansible-lint whois

#
# Copia clave privada de Vagrant para conectarse a las MVs
#
# Para evitar problemas con Windows y los permisos, en lugar de utilizar las
# claves privadas compartidas en /vagrant/.vagrant/... copiamos las claves
# privadas dentro de la MV `ansible` y establecemos los permisos adecuados
#
mkdir -p ./private_keys
cp -vf /vagrant/.vagrant/machines/dns/virtualbox/private_key ./private_keys/dns.key.rsa
cp -vf /vagrant/.vagrant/machines/negocio/virtualbox/private_key ./private_keys/negocio.key.rsa
chown vagrant:vagrant ./private_keys/*
chmod 600 ./private_keys/*

# Copiar ficheros de ansible y playbooks
# Descomentar las siguientes líneas según vayamos teniendo los ficheros y
# hacer `vagrant provision ansible`
cp -vf /vagrant/ansible.cfg .
cp -vf /vagrant/inventory.yml .
cp -vf /vagrant/requirements.yml .
chown vagrant:vagrant ./ansible.cfg ./inventory.yml