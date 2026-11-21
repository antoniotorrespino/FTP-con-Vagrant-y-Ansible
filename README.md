# FTP con Vagrant y Ansible

**Autor:** Antonio Torres Pino
**Repositorio:** https://github.com/antoniotorrespino/FTP-con-Vagrant-y-Ansible

## Objetivo del proyecto

Desplegar de forma automatizada, con Vagrant y Ansible, una pequeña infraestructura de tres máquinas virtuales con un servidor DNS (BIND9), un servidor web (Apache) y un servidor FTP seguro (vsftpd con FTP explícito sobre TLS). Los usuarios `ana` y `juan` acceden por FTP: `ana` publica páginas web en `/var/www/html` y `juan` queda enjaulado en su directorio personal.

## Máquinas virtuales

| Máquina | Nombre | IP | Función |
|---|---|---|---|
| `dns` | dns.antoniotorres.test | 192.168.57.5 | Servidor DNS (BIND9) |
| `ansible` | ansible.antoniotorres.test | 192.168.57.6 | Nodo de control de Ansible |
| `negocio` | negocio.antoniotorres.test | 192.168.57.7 | Servidor web (Apache) y FTP seguro (vsftpd) |

Los nombres `www.antoniotorres.test` y `ftp.antoniotorres.test` son alias (CNAME) de `negocio`.

## Herramientas utilizadas

- GitHub (repositorio, issues y GitHub Projects)
- Git
- VirtualBox
- Vagrant (imagen `debian/bookworm64`)
- Ansible (con Ansible Vault y la colección `community.crypto`)
- BIND9, Apache2 y vsftpd

## Estructura del proyecto

```
├── LICENSE
├── README.md
├── Vagrantfile
├── ansible.cfg
├── inventory.yml
├── requirements.yml
├── script/ansible.sh      # prepara el nodo de control de Ansible
├── dns/                   # playbook, zonas de BIND y test.sh
├── web/                   # playbook de Apache, index.html y test.sh
├── ftp/                   # playbook, vsftpd.conf y vault cifrado
└── capturas/              # capturas de las pruebas con FileZilla
```

## Requisitos

Git, VirtualBox y Vagrant instalados. Para las pruebas con cliente gráfico, FileZilla.

## Puesta en marcha

1. Clonar el repositorio y entrar en la carpeta:

   ```
   git clone https://github.com/antoniotorrespino/FTP-con-Vagrant-y-Ansible.git
   cd FTP-con-Vagrant-y-Ansible
   ```

2. Crear en la raíz el archivo `vault_pass.txt` con la contraseña del vault (`daw` en esta práctica). No se sube al repositorio porque está en `.gitignore`.

3. Crear las máquinas virtuales:

   ```
   vagrant up
   vagrant status
   ```

   El provisionamiento del nodo `ansible` ejecuta los playbooks de DNS, web y FTP.

4. Para usar los nombres desde Windows, ejecutar en PowerShell como administrador:

   ```
   Add-DnsClientNrptRule -Namespace ".antoniotorres.test" -NameServers "192.168.57.5"
   ```

## Ejecución manual de los playbooks

```
vagrant ssh ansible
ansible-playbook dns/dns.yml
ansible-playbook web/web.yml
ansible-playbook ftp/ftp.yml --vault-password-file ./.vault_pass.txt
```

## Pruebas

- DNS: `vagrant ssh dns -c "bash /vagrant/dns/test.sh"`
- Web: `vagrant ssh ansible -c "bash /vagrant/web/test.sh"` y `http://www.antoniotorres.test`
- FTP con TLS: `curl -k --ssl-reqd --user ana:ana ftp://ftp.antoniotorres.test/`

Si el PC se suspende con las máquinas encendidas, el reloj de las VMs puede quedar desfasado y `apt` rechazar los repositorios. Se evita apagándolas con `vagrant halt` al terminar.

## Usuarios FTP

| Usuario | Contraseña | Comportamiento |
|---|---|---|
| `ana` | `ana` | Sin jaula. Su raíz
