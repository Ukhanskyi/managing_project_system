# Codica Test Task for MANAGING PROJECT SYSTEM

## Usage

Devise requires master.key to run this API correctly.
Put `d1e3682323230325aff7a5ed53ec92e1` inside `config/master.key` for running this app.

### Local run Recommendations

1. Clone the new repository to your local machine
`git@github.com:Ukhanskyi/managing_project_system.git` or `https://github.com/Ukhanskyi/managing_project_system.git`
1. Run `bundle install`
1. Run `rails db:create db:migrate db:seed`
1. Run `rails s` to start your api server on port 3000
1. For testing this API please use [Postman](https://elements.getpostman.com/redirect?entityId=9811729-b97bbb9e-6fb6-45e7-a289-70a3963c2fb3&entityType=collection) or [Swagger](http://localhost:3000/api-docs/index.html) (when your local server is running)

### Docker run Recommendations

1. Run `docker-compose build`
1. Run `docker-compose run web rails db:create db:migrate db:seed`
1. Run `docker-compose up`

### Additional commands

1. Run spec `docker-compose run web rspec`
1. Run rubocop `docker-compose run web rubocop`
1. Run swagger `docker-compose run web rails rswag`

### Links

1. Swagger `http://localhost:3000/api-docs/index.html` or `http://0.0.0.0:3000/api-docs/index.html`
1. Postman `https://elements.getpostman.com/redirect?entityId=9811729-b97bbb9e-6fb6-45e7-a289-70a3963c2fb3&entityType=collection`
