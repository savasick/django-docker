#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 2
    done

    echo "PostgreSQL started"
fi


python manage.py flush --no-input
python manage.py makemigrations core --no-input
python manage.py migrate core
python manage.py migrate
DJANGO_SUPERUSER_PASSWORD=$SUPER_USER_PASSWORD python manage.py createsuperuser --username $SUPER_USER_NAME --email $SUPER_USER_EMAIL --noinput
python manage.py collectstatic --noinput

exec "$@"