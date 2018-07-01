Ibotta Anagram Project
=========

#### Ruby 2.4.4
#### Rails 5.1.6

---
The project is to build an API that allows fast searches for [anagrams](https://en.wikipedia.org/wiki/Anagram). `dictionary.txt` is a text file containing every word in the English dictionary. Ingesting the file doesn’t need to be fast, and you can store as much data in memory as you like.

The API you design should respond on the following endpoints as specified.

- `POST /words.json`: Takes a JSON array of English-language words and adds them to the corpus (data store).
- `GET /anagrams/:word.json`:
  - Returns a JSON array of English-language words that are anagrams of the word passed in the URL.
  - This endpoint should support an optional query param that indicates the maximum number of results to return.
- `DELETE /words/:word.json`: Deletes a single word from the data store.
- `DELETE /words.json`: Deletes all contents of the data store.

*Note: This project is a work in progress*

**Optional**
- Endpoint that returns a count of words in the corpus and min/max/median/average word length
- Respect a query param for whether or not to include proper nouns in the list of anagrams
- Endpoint that identifies words with the most anagrams
- Endpoint that takes a set of words and returns whether or not they are all anagrams of each other
- Endpoint to return all anagram groups of size >= *x*
- Endpoint to delete a word *and all of its anagrams*

### Dependencies

This service has dependencies on the following services:

1. Ruby `2.4.4`
1. MongoDB
1. Redis
1. Sidekiq

### Docker
Follow the Docker [Getting Started](https://docs.docker.com/get-started/) guide to get `docker` and `docker-compose`.  This project contains helper scripts to build and test services.

1. Run the test suite: `$ script/test`

#### Local development
To start the application using docker compose locally:

1. Start the services: `$ docker-compose up --build`
1. Access Sidekiq via browser: `$ open http://localhost:3000/sidekiq`

### Local development (without Docker)
To start the application from project folder:

1. Start Redis: `$ redis-server`
1. Start Sidekiq: `$ bundle exec sidekiq`
1. Start App: `$ rails s`
1. Access Sidekiq via browser: `$ open http://localhost:3000/sidekiq`

### Database

#### Create Indexes

A rake task needs to be executed the first time the project is set up in order to create Mongo indexes.

1. `docker-compose run app rake db:create_indexes` (Docker)
1. `rake db:create_indexes` (Local)

#### Seed Database

A rake task was created in order to seed the database with the provided `dictionary.txt.gz` file.
This task is designed to use Sidekiq to enqueue and process the dictionary in ascending order.

*Note: The default word limit is **1_000***

1. `docker-compose run app rake dictionary:enqueue` (Docker)
1. `rake dictionary:enqueue` (Local)
1. `rake dictionary:enqueue\[50\]` (First 50 words)

### Testing

With the services running, the provided test suite can be executed by running the following command:

1. `$ ruby vendor/ibotta/anagram_test.rb`

#### Rspec

The project includes a test suite for all major functionality of the API.

1. `script/test` (Docker)
1. `bundle exec rspec` (Local)

### Environment Variables

| Variable       |  Description   | Default                 |
| ---------------|:---------------|:-----------------------:|
| `MONGODB_URI`  | MongoDB URI   | mongodb://localhost:27017/anagrams_development |
| `REDIS_CACHE_URL`  | Redis Cache URL   | redis://localhost:6379/0 |
| `REDIS_WORKER_URL`  | Redis Worker URL  | redis://localhost:6379/1 |
| `DB_MAX_CONNECTIONS`  | Mongo Max Connections  | 16 |
| `DB_MIN_CONNECTIONS`  | Mongo Min Connections | 5 |
| `DB_WAIT_QUEUE_TIMEOUT`  | DB Queue Timeout  | 5 |
| `DB_CONNECT_TIMEOUT`  | DB Connection Timeout  | 10 |
| `DB_SOCKET_TIMEOUT`  | DB Socket Timeout | 5 |
