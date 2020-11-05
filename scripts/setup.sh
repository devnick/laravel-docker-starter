#!/bin/bash
echo -e "Bringing down project and removing volumes ..."
docker-compose down -v
echo -e "Building containers ..."
docker-compose build
echo -e "Start the database ..."
docker-compose up -d db
echo -e "Install JavaScript dependencies ..."
docker-compose run --rm node npm install
echo -e "Install PHP dependencies ..."
docker-compose run --rm app composer install
echo -e "Copy environment file ..."
cp ./application/.env.example ./application/.env
echo -e "Generate application key ..."
docker-compose run --rm app php artisan key:generate
echo -e "Run database migrations ..."
docker-compose run --rm app php artisan migrate:fresh --seed
echo -e "Run the project ..."
docker-compose up