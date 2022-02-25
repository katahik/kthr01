#!/bin/bash

ROOT=/home/ec2-user/kthr01/src
RENV=production

cd $ROOT

start() {


    echo -e "\n\n\n"
    echo "=================================================="
    echo "bundle install starting."
    echo "=================================================="
    docker-compose run --rm web bundle install --without development test

    echo -e "\n\n\n"
    echo "=================================================="
    echo "db:migrate starting."
    echo "=================================================="
    docker-compose run --rm web bundle exec rake db:migrate RAILS_ENV=$RENV

    echo -e "\n\n\n"
    echo "=================================================="
    echo "assets:precompile starting."
    echo "=================================================="
    docker-compose run --rm web bundle exec rails assets:precompile RAILS_ENV=$RENV

    echo -e "\n\n\n"
    echo "=================================================="
    echo "yarn install."
    echo "=================================================="
    docker-compose run --rm web yarn install --check-files

    echo -e "\n\n\n"
    echo "=================================================="
    echo "sudo rm -rf /home/ec2-user/kthr01/src/db/mysql_data/"
    echo "=================================================="
    sudo rm -rf /home/ec2-user/kthr01/src/db/mysql_data/

    echo -e "\n\n\n"
    echo "=================================================="
    echo "container building."
    echo "=================================================="
    docker-compose build --build-arg RAILS_ENV=production --no-cache

    echo -e "\n\n\n"
    echo "=================================================="
    echo "container start."
    echo "=================================================="
    docker-compose up -d
}

stop() {
    echo -e "\n\n\n"
    echo "=================================================="
    echo "container stop & remove."
    echo "=================================================="
    docker-compose down
}

restart() {
    stop
    start
}

git-update() {
    echo -e "\n\n\n"
    echo "=================================================="
    echo "git pull --prune origin main"
    echo "=================================================="
    git pull --prune origin main
}

renewal() {
    stop
    git-update
    start
}

case "$1" in
    start)
        $1
        ;;
    stop)
        $1
        ;;
    git-update)
        $1
        ;;
    renewal)
        $1
        ;;
    restart)
        $1
        ;;
    *)
        echo $"Usage: $0 {start|stop|git-update|renewal|restart}"
        exit 2
esac

