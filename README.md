# README

1. Install all dependencies with `bundle install`
2. Start the server with `rails server`
3. Start the redis server with `redis-server`

## Make API request

- **api/v1/passengers?metric=(starship|starships|vehicle|vehicles)**
- **api/v1/cost_in_credits?metric=(starship|starships|vehicle|vehicles)**
- **api/v1/cargo_capacity?metric=(starship|starships|vehicle|vehicles)**
- **api/v1/appeared_in_same_films?film_number=Number**

## Specs

Run the spesc with **bundle exec rspec**
