#!/usr/bin/env bash
export $(cat secrets)

docker-compose build
docker-compose up --force-recreate