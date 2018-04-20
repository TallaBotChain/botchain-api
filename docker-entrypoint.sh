#!/bin/bash

# fail fast
set -e
export RACK_ENV=$APP_ENV
export RAILS_ENV=$APP_ENV

function wait_for_host_port {
  if [[ $# != 2 ]]; then echo "usage: $FUNCNAME host port"; return 1; fi

  host=$1
  port=$2
  echo "Waiting for $host:$port to become available"
  while ! nc -z $host $port  > /dev/null 2>&1; do echo .; sleep 2; done
  echo "The service on $host:$port is now available"
}

function wait_for_services {
  for svc in $SERVICES; do
    host=${svc%%:*}
    port=${svc##*:}
    wait_for_host_port ${!host} ${!port}
  done
}

function app_init {
  # Run bundler if needed - useful in dev
  if [[ "$APP_ENV" == "development" ]]; then
    bundle check || bundle install
  fi
}
export -f app_init

function db_init {
  echo "Setting up db"
  bundle exec rake db:create db:migrate db:seed
}
export -f db_init

function db_reset {
  echo "Resetting db"
  bundle exec rake db:reset
}
export -f db_reset

function db_migrate {
  echo "Migrating db"
  bundle exec rake db:migrate
}
export -f db_migrate

function db_seed {
  echo "Seeding db"
  bundle exec rake db:seed
}
export -f db_seed

function start_app {
  rm -f tmp/pids/*
  exec bundle exec rails server -b 0.0.0.0 -p $APP_PORT -e $APP_ENV
}
export -f start_app

function start_console {
  exec bundle exec rails console -e $APP_ENV
}
export -f start_app

function start_worker {
  echo "Starting worker"
  exec bundle exec rake worker
}
export -f start_worker

action=$1; shift

case $action in

  app)
    wait_for_services
    app_init
    db_init
    start_app
  ;;

  worker)
    wait_for_services
    app_init
    db_init
    start_worker
  ;;

  console)
    wait_for_services
    app_init
    db_init
    start_console
  ;;

  db_init)
    wait_for_services
    db_init
  ;;

  db_reset)
    wait_for_services
    db_reset
  ;;

  db_migrate)
    wait_for_services
    db_migrate
  ;;

  db_seed)
    wait_for_services
    db_seed
  ;;

  test)
    wait_for_services
    export RAILS_ENV=test RACK_ENV=test
    app_init
    db_init
    echo "Starting tests"
    bundle exec rspec
  ;;

  bash)
    exec bash -il
  ;;

  exec)
    exec "$@"
  ;;

  *)
    echo "Invalid action: $action"
    exit 1
  ;;

esac
