FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /flix
WORKDIR /flix
COPY Gemfile /flix/Gemfile
COPY Gemfile.lock /flix/Gemfile.lock
RUN bundle install
COPY . /flix
