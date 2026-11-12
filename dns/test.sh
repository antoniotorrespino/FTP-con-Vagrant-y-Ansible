#!/usr/bin/env bash
# Pruebas de los registros DNS del servidor 192.168.57.5
set -u

SERVER=192.168.57.5
DOMAIN=antoniotorres.test
fallos=0

comprobar() {
  local descripcion="$1"
  local esperado="$2"
  shift 2
  local obtenido
  obtenido=$(dig +short +time=2 +tries=1 @"$SERVER" "$@")
  if [ "$obtenido" = "$esperado" ]; then
    echo "OK    $descripcion -> $obtenido"
  else
    echo "FALLO $descripcion (esperado '$esperado', obtenido '$obtenido')"
    fallos=$((fallos + 1))
  fi
}

comprobar "dns A"               "192.168.57.5"          dns.$DOMAIN A
comprobar "negocio A"           "192.168.57.7"          negocio.$DOMAIN A
comprobar "www CNAME"           "negocio.$DOMAIN."      www.$DOMAIN CNAME
comprobar "ftp CNAME"           "negocio.$DOMAIN."      ftp.$DOMAIN CNAME
comprobar "PTR 192.168.57.5"    "dns.$DOMAIN."          -x 192.168.57.5
comprobar "PTR 192.168.57.7"    "negocio.$DOMAIN."      -x 192.168.57.7

if [ "$fallos" -eq 0 ]; then
  echo "Todas las pruebas son correctas"
  exit 0
else
  echo "$fallos prueba(s) fallida(s)"
  exit 1
fi