FROM docker.io/ruby:3.0.3-alpine

RUN gem install foreman bundle

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true

WORKDIR /app
COPY .ruby-version .
COPY Gemfile* ./
RUN bundle install

COPY . .

RUN bundle install

EXPOSE 3009

CMD ["sh", "-c", "rails db:migrate && foreman start -f Procfile"]
