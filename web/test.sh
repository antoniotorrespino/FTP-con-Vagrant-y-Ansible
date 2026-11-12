#!/usr/bin/env bash
# Prueba del servidor web: comprueba el código HTTP y el texto de la página
set -u

URL="http://192.168.57.7/"
TEXTO="Servidor web de antoniotorres.test"

codigo=$(curl -s -o /tmp/respuesta.html -w "%{http_code}" "$URL")

if [ "$codigo" = "200" ] && grep -q "$TEXTO" /tmp/respuesta.html; then
  echo "OK    $URL responde 200 y contiene '$TEXTO'"
  exit 0
else
  echo "FALLO $URL (código HTTP: $codigo)"
  exit 1
fi