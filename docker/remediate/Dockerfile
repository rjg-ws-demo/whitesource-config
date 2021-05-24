# This default may be swapped for any compatible base image
ARG BASE_IMAGE=amd64/ubuntu:20.04

# This buildpack is used for tool intallation and user/directory setup
FROM containerbase/buildpack:1.6.0@sha256:ae411ab0b74176c3db1d9213cd5d40e57b03b77d56375702ee05379a437ac742 AS buildpack

FROM ${BASE_IMAGE} as base

# The buildpack supports custom user but Renovate requires ubuntu
ARG USER_NAME=ubuntu
ARG USER_ID=1000
ARG APP_ROOT=/usr/src/app

# Set env and shell
ENV BASH_ENV=/usr/local/etc/env
SHELL ["/bin/bash" , "-c"]

# Set up buildpack
COPY --from=buildpack /usr/local/bin/ /usr/local/bin/
COPY --from=buildpack /usr/local/buildpack/ /usr/local/buildpack/
RUN install-buildpack

# --------------------------------------------------------------
# The following packages are mandatory for installs and runtime
# --------------------------------------------------------------

# renovate: datasource=github-tags depName=git lookupName=git/git
ARG GIT_VERSION=v2.31.1
RUN install-tool git

# renovate: datasource=github-releases depName=node lookupName=nodejs/node versioning=node
ARG NODE_VERSION=14.17.0
RUN install-tool node

# renovate: datasource=npm depName=yarn versioning=npm
ARG YARN_VERSION=1.22.10
RUN install-tool yarn

# -------------------------------------------------------------------------------------
# Any of the below third-party tools may be commented out to save space and build time
# -------------------------------------------------------------------------------------

# renovate: datasource=docker depName=openjdk versioning=docker
ARG JAVA_VERSION=11.0.11
RUN install-tool java

# renovate: datasource=gradle-version depName=gradle versioning=gradle
ARG GRADLE_VERSION=6.9
RUN install-tool gradle

ARG ERLANG_VERSION=22.3.2
RUN install-tool erlang

# renovate: datasource=docker depName=elixir versioning=docker
ARG ELIXIR_VERSION=1.11.4
RUN install-tool elixir

# renovate: datasource=github-releases depName=php lookupName=containerbase/php-prebuild
ARG PHP_VERSION=7.4.19
RUN install-tool php

# renovate: datasource=github-releases depName=composer lookupName=composer/composer
ARG COMPOSER_VERSION=2.0.13
RUN install-tool composer

# renovate: datasource=docker depName=golang versioning=docker
ARG GOLANG_VERSION=1.16.4
RUN install-tool golang

# renovate: datasource=github-releases depName=python lookupName=containerbase/python-prebuild
ARG PYTHON_VERSION=3.9.3
RUN install-tool python

# renovate: datasource=pypi depName=pipenv
ARG PIPENV_VERSION=2020.11.15
RUN install-pip pipenv

# renovate: datasource=github-releases depName=poetry lookupName=python-poetry/poetry
ARG POETRY_VERSION=1.1.6
RUN install-tool poetry

# renovate: datasource=pypi depName=hashin
ARG HASHIN_VERSION=0.15.0
RUN install-pip hashin

# renovate: datasource=docker depName=rust versioning=docker
ARG RUST_VERSION=1.52.1
RUN install-tool rust

# renovate: datasource=github-releases depName=ruby lookupName=containerbase/ruby-prebuild versioning=ruby
ARG RUBY_VERSION=3.0.1
RUN install-tool ruby

# renovate: datasource=rubygems depName=cocoapods versioning=ruby
ARG COCOAPODS_VERSION=1.10.1
RUN install-gem cocoapods

# renovate: datasource=npm depName=pnpm versioning=npm
ARG PNPM_VERSION=5.18.9
RUN install-tool pnpm

# renovate: datasource=docker depName=dotnet lookupName=mcr.microsoft.com/dotnet/sdk
ARG DOTNET_VERSION=3.1.409
RUN install-tool dotnet

# renovate: datasource=npm depName=lerna versioning=npm
ARG LERNA_VERSION=3.22.1
RUN install-npm lerna

# renovate: datasource=github-releases depName=helm lookupName=helm/helm
ARG HELM_VERSION=v3.5.4
RUN install-tool helm

# ---------------------------------------------
# Set up of custom server - do not modify
# ---------------------------------------------

WORKDIR ${APP_ROOT}

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

ARG SERVER_SRC=src/server.js
ARG SERVER_DST=src/server.js

COPY ${SERVER_SRC} ${SERVER_DST}

ARG WS_PLATFORM=enterprise
ENV WS_PLATFORM=${WS_PLATFORM}

# This entry point ensures that dumb-init is run
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "node", "src/server.js" ]

EXPOSE 8080

# Override home for openshift and add user bin to path
ENV HOME=/home/$USER_NAME PATH=/home/$USER_NAME/bin:$PATH

USER $USER_ID
