# README

## Pre-requisites

[Install docker](https://store.docker.com/editions/community/docker-ce-desktop-mac)

## Running application

### Everything

```
docker-compose build
docker-compose up
```

### Piecemeal
```
# start only postgres in background
docker-compose up -d postgres
# start only app server
docker-compose up app
# run tests
docker-compose run test test
# run console within container
docker-compose run app console
# run bash within container
docker-compose run app bash

```
