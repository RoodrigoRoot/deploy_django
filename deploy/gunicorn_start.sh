pip install gunicorn

#!/bin/bash

NAME="deploy_django" # Nombre de la aplicación
DJANGODIR=/home/roodrigo/apolo/deploy_django/ #Ruta de la carpeta de la aplicación
SOCKFILE=/home/roodrigo/apolo/run/gunicorn.sock #Ruta donde se creará el archivo de socket unix para comunicarnos
LOGDIR=${DJANGODIR}logs/gunicorn.log #Carpeta donde estara los logs del gunicorn
USER=roodrigo #Usuario con el que vamos a correr el sitio web
GROUP=roodrigo #Grupo con el que vamos a correr el sitio web
NUM_WORKERS=3 #Número de procesos que se van a utilizar para correr la aplicación
DJANGO_SETTINGS_MODULE=config.production #Ruta de los settings
DJANGO_WSGI_MODULE=config.wsgi #Nombre del módulo wsgi

# Activar el entorno virtual
cd $DJANGODIR
source ../env/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Crear la carpeta run si no existe para guardar el socket linux
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Iniciar la aplicación django por medio de gunicorn
exec ../env/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
--name $NAME \
--workers $NUM_WORKERS \
--user=$USER --group=$GROUP \
--bind=unix:$SOCKFILE \
--log-level=debug \
--log-file=-


