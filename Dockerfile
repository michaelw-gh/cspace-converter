FROM ruby:2.3.5

RUN apt-get update && apt-get install -y nodejs
RUN mkdir app
WORKDIR app

COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock

RUN bundle install -j 20
COPY . .
