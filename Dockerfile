FROM node:alpine as builder

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
# Gevent install is super slow...cache it early
RUN pip install gevent

ARG CABOT_VERSION
RUN git clone https://github.com/clouetb/cabot /code

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements-dev.txt
RUN pip install --no-cache-dir -r requirements-plugins.txt

RUN python3 manage.py collectstatic --noinput
RUN python3 manage.py compress
RUN python3 setup.py sdist bdist_wheel

FROM python:alpine

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
        musl-dev \
        curl-dev \
        libcurl \
        libffi-dev \
        openldap-dev \
        ca-certificates \
        bash \
        git

# Gevent install is super slow...cache it early
RUN pip install gevent
COPY --from=builder /code/dist/*.whl /tmp/
RUN pip install --no-cache-dir --disable-pip-version-check /tmp/*.whl
RUN rm -rf /tmp

RUN apk del \
        python3-dev \
        gcc \
        musl-dev \
        libffi-dev \
        openldap-dev

ENTRYPOINT []
CMD ["/bin/sh"]
