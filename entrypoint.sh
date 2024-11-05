#!/bin/sh

if [ "$DJANGO_DATABASE_ENGINE" = "django.db.backends.postgresql" ]; then
	echo "Waiting for postgres..."
	while ! nc -z $DJANGO_DATABASE_HOST "${DJANGO_DATABASE_PORT:-5432}"; do
		sleep 0.1
	done

	echo "PostgreSQL is running chief!"
fi

python manage.py migrate

python manage.py check --deploy

exec "$@"

