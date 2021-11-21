FROM docker.io/ruby:3.0.2

RUN gem install foreman bundle

WORKDIR /app
COPY .ruby-version .
COPY Gemfile* ./
RUN bundle install

COPY . .

EXPOSE 3009
CMD ["foreman", "start", "-f", "Procfile"]