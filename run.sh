#!/bin/bash

set -e

if ! command -v python3 &>/dev/null; then
    echo "Python3 is not installed. Please install Python3."
    exit 1
fi

if [ ! -f secret.py ]; then
    cp secret.py.example secret.py
    echo "Please edit the secret.py file and add in your secrets."
    exit 1
fi

if [ ! -f database.db ]; then
    echo "A database file was not found."
    echo "Auto-generating a database file."
    python3 dbSetup.py
fi

export FLASK_APP=app

if [[ $1 == dev ]]; then
    echo "Using Development environment"
    export FLASK_ENV=development
    flask run
elif [[ $1 == prod ]]; then
    echo "Using production environment"
    gunicorn -w 4 -b 127.0.0.1:5000 app:app
else
    echo "!!! Using production environment since argument was not provided. To use dev setup, use './run.sh dev'"
    gunicorn -w 4 -b 127.0.0.1:5000 app:app
fi