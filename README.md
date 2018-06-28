# Ibotta Anagram Project

The project is to build an API that allows fast searches for [anagrams](https://en.wikipedia.org/wiki/Anagram). `dictionary.txt` is a text file containing every word in the English dictionary. Ingesting the file doesn’t need to be fast, and you can store as much data in memory as you like.

The API you design should respond on the following endpoints as specified.

- `POST /words.json`: Takes a JSON array of English-language words and adds them to the corpus (data store).
- `GET /anagrams/:word.json`:
  - Returns a JSON array of English-language words that are anagrams of the word passed in the URL.
  - This endpoint should support an optional query param that indicates the maximum number of results to return.
- `DELETE /words/:word.json`: Deletes a single word from the data store.
- `DELETE /words.json`: Deletes all contents of the data store.


**Optional**
- Endpoint that returns a count of words in the corpus and min/max/median/average word length
- Respect a query param for whether or not to include proper nouns in the list of anagrams
- Endpoint that identifies words with the most anagrams
- Endpoint that takes a set of words and returns whether or not they are all anagrams of each other
- Endpoint to return all anagram groups of size >= *x*
- Endpoint to delete a word *and all of its anagrams*

*Note: This project is a work in progress*

### Dependencies

This service has dependencies on the following services:

1. Ruby `2.4.4`
1. MongoDB
1. Redis

### Docker
Follow the Docker [Getting Started](https://docs.docker.com/get-started/) guide to get `docker` and `docker-compose`.  This project contains helper scripts to build and test services.

1. Run the test suite: `$ script/test`

#### Local development
To start the application using docker compose locally:

1. Start the services: `$ docker-compose up --build`
1. Access via browser: `$ open http://localhost:3000/hello`

### Environment Variables

| Variable       |  Description   | Default                 |
| ---------------|:---------------|:-----------------------:|
| `APP_NAME`     | App name       |                         |
| `MONGODB_URI`  | Mongo DB URI   | mongodb://localhost:27017/anagrams_development |
