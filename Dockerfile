FROM python:3.12.7

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

COPY ./entrypoint.sh .

COPY . .

ENTRYPOINT [ "/app/entrypoint.sh"]

