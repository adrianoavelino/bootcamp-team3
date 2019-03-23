# README

* **Montando o projeto:**

git clone https://github.com/pedromschmitt/bootcamp-team3.git

docker-compose build

* **lembre de rodar para evitar erros:**

sudo chown -R $USER:$USER *.*

* **Depois:**

docker-compose run --rm app bundle install

docker-compose run --rm app bundle exec rails db:create db:migrate
