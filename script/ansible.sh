#!/usr/bin/env bash
#
# Configura el servidor como un nodo de control de Ansible
#
set -xeu
export DEBIAN_FRONTEND=noninteractive

# Instalar ansible
apt-get update
apt-get install -y ansible ansible-lint whois curl

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
chown -R vagrant:vagrant ./private_keys
chmod 600 ./private_keys/*

# Copiar ficheros de ansible y playbooks
cp -vf /vagrant/ansible.cfg .
cp -vf /vagrant/inventory.yml .
cp -vf /vagrant/requirements.yml .
chown vagrant:vagrant ./ansible.cfg ./inventory.yml ./requirements.yml

cp -vrf /vagrant/dns .
chown -R vagrant:vagrant ./dns

cp -vrf /vagrant/web .
chown -R vagrant:vagrant ./web

cp -vrf /vagrant/ftp .
chown -R vagrant:vagrant ./ftp

# Copiar contraseña del vault
cp -vf /vagrant/vault_pass.txt ./.vault_pass.txt
chown vagrant:vagrant ./.vault_pass.txt
chmod 600 ./.vault_pass.txt