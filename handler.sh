#!/bin/bash

function run_migrations() {
    echo "Running migrations"
    python3 manage.py makemigrations
    python3 manage.py migrate
}

function run_exposed() {
    echo "Running locally exposed on port $1"
    python3 manage.py runserver 0:$1
}

function run_unexposed() {
    echo "Running locally unexposed on port $1"
    python3 manage.py runserver $1
}

PORT_DEFAULT=8000

for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)

   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"

   export "$KEY"="$VALUE"
done

if [[ -n $COMMAND && $COMMAND == "migrate" ]]; then
    run_migrations
elif [[ -n $COMMAND && $COMMAND == "run" ]]; then
    if [[ $PORT ]]; then
        if [[ $MODE == "exposed" ]]; then
            run_exposed $PORT
        else
            run_unexposed $PORT
        fi
    else
        if [[ $MODE == "exposed" ]]; then
            run_exposed $PORT_DEFAULT
        else
            run_unexposed $PORT_DEFAULT
        fi
    fi
else
    echo "Invalid command"
fi
