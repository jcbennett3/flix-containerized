# **Heroku and Rails for Windows users**
who want to be Linux users

---

## Description
Skeleton docker/rails application for use with Pragmatic Studios ***Flix*** exercise



## Requirements
* (docker)[https://docs.docker.com/install/]
* (docker-compose)[https://docs.docker.com/compose/install/]

## Instructions
>Create a file within your app's root directory named ***Dockerfile*** (no file extension, just "Dockerfile")
>Copy the following into your dockerfile and save.
```sh
FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /<your app name>
WORKDIR /{your app name>
COPY Gemfile /<your app name>/Gemfile
COPY Gemfile.lock /<your app name>/Gemfile.lock
RUN bundle install
COPY . /<your app name>
```
>From within ${your_app}/config, find and rename ***database.yml*** to ***old_database.yml***
>Create a new file of the same name, in the same location. Save both files for now.
>Within your application's root directory, create a file named ***docker-compose.yml***
>Copy the following into ***docker-compose.yml*** and save.
```yaml
version: '3'
services:
  db:
    image: postgres
  web:
    build: .
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    volumes:
      - .:/<your app name>
    ports:
      - "3000:3000"
    depends_on:
      - db
```
>Open your new ***database.yml*** file, and, after replacing <your app name> with your application's name in both locations, save it with the following contents:
```sh
default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  username: postgres
  password:
  pool: 5

development:
  <<: *default
  database: <your app name>_development


test:
  <<: *default
  database: <your app name>_test
```
>From your command line, run
  ```sh
  docker-compose up --build
  ```
 >At this point you should see something similar to the following:
  ```sh
  Starting rails_db_1 ...
Starting rails_db_1 ... done
Recreating rails_web_1 ...
Recreating rails_web_1 ... done
Attaching to rails_db_1, rails_web_1
db_1   | LOG:  database system was shut down at 2017-06-07 19:12:02 UTC
db_1   | LOG:  MultiXact member wraparound protections are now enabled
db_1   | LOG:  database system is ready to accept connections
db_1   | LOG:  autovacuum launcher started
web_1  | => Booting Puma
web_1  | => Rails 5.0.0.1 application starting in development on http://0.0.0.0:3000
web_1  | => Run `rails server -h` for more startup options
web_1  | Puma starting in single mode...
web_1  | * Version 3.9.1 (ruby 2.3.3-p222), codename: Private Caller
web_1  | * Min threads: 5, max threads: 5
web_1  | * Environment: development
web_1  | * Listening on tcp://0.0.0.0:3000
web_1  | Use Ctrl-C to stop
  ```
>:exclamation: In a separate terminal :exclamation: run:
```sh
docker-compose run web rails db:create
```
>You should then see something like this:
```sh
Starting rails_db_1 ... done
Created database 'flix_development'
Created database 'flix_test'
```

>From here, stop your server.  To do this, run:
```sh
    docker-compose down
```
>from your original terminal.
>You *can* just `ctrl-c` to exit, as usual, but this is known to cause the error:
```sh
web_1 | A server is already
running. Check /flix/tmp/pids/server.pid.
```
>when attempting to restart your server.  If that's the case, just remove the aforementioned pid file and you're on your way.

# Restarting your application
```docker-compose up```
>from within your project's root directory (i.e. make sure you can see your dockerfile when checking your directory)
>In another terminal, run ```docker-compose run web rails db:create```
---
>At this point, you should be able to view your application in the browser, just as if you were running it without docker.
