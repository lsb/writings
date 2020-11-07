FROM ruby:alpine
RUN apk add --no-cache build-base nodejs git && gem install bundler
WORKDIR /jkl
ARG GEMFILELOCK
ARG GEMFILE
RUN echo $GEMFILE | base64 -d > Gemfile
RUN echo $GEMFILELOCK | base64 -d > Gemfile.lock
RUN touch Gemfile
RUN bundle install

