FROM ruby:alpine
RUN apk add --no-cache build-base nodejs git && gem install bundler
WORKDIR /jkl
ADD Gemfile .
RUN bundle install

