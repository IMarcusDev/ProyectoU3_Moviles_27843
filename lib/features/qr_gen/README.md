# QR Generation

El presente feature genera imágenes QRs con el identificador de cada lugar.

## Instalación

Es preferible realizar todo en un entorno virtual `venv`.

```sh
py -m venv venv

# Activar entorno
source venv/bin/activate
```

Al activar el entorno, debería verse el nombre del entorno al inicio de la consola:

```sh
$ (venv) USER@linux:~
```

Además de esto, es importante generar el `serviceKey.json`, que genera la base de datos Firebase en [la página web](https://console.firebase.google.com/project/examenu3-b6f08/settings/serviceaccounts/adminsdk).
Este archivo está configurado para leerse dentro del entorno virtual `/venv/serviceKey.json`.

## Funcionamiento

1. Cambiar el _place_ o lugar, siguiendo la estructura del objeto que se guarda dentro del script `addPlaceToFirebase.py`.

```py
{
  "name": "Lugar de Prueba",
  "description": "Este es un lugar de prueba, únicamente para comprobar si funciona correctamente.",
  "latitude": 0,
  "longitude": 0,
  "interestVector": {
    "culture": 1,
    "gastronomy": 0,
    "hotel": 0,
    "nature": 0
  }
}

```

2. Ejecutar el script `main.sh`.
