# Programadoro

## Instalação
- clone o projeto:
    ```sh
    git clone https://github.com/pedromschmitt/bootcamp-team3.git
    ```
- construa os container:
    ```sh
    docker-compose build
    ```
- configure a permissão dos arquivos:
    ```sh
    sudo chown -R $USER:$USER *.*
    ```
- instale as dependência do ruby:
    ```sh
    docker-compose run --rm app bundle install
    ```
- instale as dependências do yarn:
    ```sh
    docker-compose run --rm app bundle exec yarn install
    ```
- crie os bancos de dados:
    ```sh
    docker-compose run --rm app bundle exec rails db:create db:migrate
    ```
- execute o projeto:
    ```sh
    docker-compose up
    ```
- acesse o projeto em: [http://localhost:3000/](http://localhost:3000/)
