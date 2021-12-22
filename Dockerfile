FROM docker.io/ruby:3.0.3-alpine

# Minimal requirements to run a Rails app
RUN apk add --no-cache --update build-base \
    linux-headers \
    git \
    postgresql-dev \
    tzdata

RUN gem install foreman bundle

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true

WORKDIR /app
COPY .ruby-version .
COPY Gemfile* ./
RUN bundle install

COPY . .

EXPOSE 3009

CMD ["sh", "-c", "rails db:migrate && foreman start -f Procfile"]
