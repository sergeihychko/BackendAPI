FROM python:3.12.7 AS base

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

FROM ghcr.io/static-web-server/static-web-server:2.33.1 AS static-server
WORKDIR /srv/http
ENV SERVER_ROOT=/srv/http

COPY --from=collectstatic /static /srv/http/static


FROM base AS dev
ENV RUN_MODE=dev


FROM base AS server
ENV RUN_MODE=prod

COPY ./entrypoint.sh .

COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]

