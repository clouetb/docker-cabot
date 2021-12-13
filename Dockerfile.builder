FROM node:alpine

ENV PYTHONUNBUFFERED 1
RUN mkdir /code

WORKDIR /code

RUN apk add --no-cache \
        python3-dev \
        py3-pip \
        cargo \
        build-base \
        autoconf \
        automake \
        py3-cryptography \
        postgresql-dev \
        gcc \
        tzdata \
        curl \
        musl-dev \
        curl-dev \
        libcurl \
        libffi-dev \
        openldap-dev \
        ca-certificates \
        bash \
        git

RUN npm install -g coffeescript less

RUN pip install --upgrade pip wheel twine

RUN curl https://raw.githubusercontent.com/clouetb/cabot/master/requirements.txt \
    --output 'requirements.txt'

RUN curl https://raw.githubusercontent.com/clouetb/cabot/master/requirements-dev.txt \
    --output 'requirements-dev.txt'

RUN curl https://raw.githubusercontent.com/clouetb/cabot/master/requirements-plugins.txt \
    --output 'requirements-plugins.txt'


RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements-dev.txt

RUN apk del \
        python3-dev \
        gcc \
        musl-dev \
        libffi-dev \
        openldap-dev

RUN rm requirements.txt requirements-dev.txt
ENTRYPOINT []
CMD ["/bin/sh"]
