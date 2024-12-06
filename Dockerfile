FROM python:3.13.1 AS base

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update \
	&& apt-get install -y \
		git \
		netcat-openbsd \
	&& rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt .
COPY ./requirements-dev.txt .
RUN pip install -r requirements-dev.txt


FROM base AS collectstatic
COPY . .
RUN DJANGO_STATIC_ROOT=/static python manage.py collectstatic --no-input
RUN find /static -ls

FROM ghcr.io/static-web-server/static-web-server:2.34.0 AS static-server
WORKDIR /srv/http
ENV SERVER_ROOT=/srv/http

COPY --from=collectstatic /static /srv/http/static


FROM base AS dev
ENV RUN_MODE=dev
COPY ./entrypoint.sh .
ENTRYPOINT ["/app/entrypoint.sh"]


FROM dev AS server
ENV RUN_MODE=prod

COPY . .
