ARG RUBY_VERSION
ARG BUNDLER_VERSION

###################
### Build stage ###
###################
FROM docker.io/ruby:${RUBY_VERSION}-alpine as builder

# Update system
RUN apk update && apk upgrade && \
    apk add --no-cache --update  \
    build-base \
    linux-headers \
    git \
    postgresql-dev \
    tzdata \
    imagemagick \
    libc6-compat

# Install bundler
ARG BUNDLER_VERSION
RUN gem install bundler --no-document -v $BUNDLER_VERSION

# Set workdir
ENV APP_HOME /app
ENV BUNDLER_DIR /vendor/bundle
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Install dependencies
ARG RAILS_ENV=production
ARG RUBY_VERSION
COPY Gemfile* $APP_HOME/
COPY .ruby-version $APP_HOME/
RUN if [[ "$RAILS_ENV" = production ]] ; then bundle config --local without development:test ; fi
RUN bundle config set --local path $BUNDLER_DIR && \
    bundle install && \
    rm -rf $APP_HOME/tmp/* && \
    rm -rf $BUNDLER_DIR/ruby/$RUBY_VERSION/cache/*.gem && \
    find $BUNDLER_DIR/ruby/$RUBY_VERSION/gems/ -name "*.c" -delete && \
    find $BUNDLER_DIR/ruby/$RUBY_VERSION/gems/ -name "*.o" -delete
COPY . $APP_HOME

########################
### Production stage ###
########################
FROM docker.io/ruby:${RUBY_VERSION}-alpine
ARG RAILS_ENV=production
ARG RAILS_SERVE_STATIC_FILES=true

# ENV variables
ENV LANG=C.UTF-8
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_ENV=$RAILS_ENV
ENV RAILS_SERVE_STATIC_FILES=$RAILS_SERVE_STATIC_FILES

# Update system
RUN apk update && apk upgrade && \
    apk add --no-cache --update \
    postgresql-client \
    tzdata \
    imagemagick \
    libc6-compat

# Set workdir
ENV APP_HOME /app
ENV BUNDLER_DIR /vendor/bundle
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY --from=builder $BUNDLER_DIR $BUNDLER_DIR
COPY --from=builder /app $APP_HOME
RUN bundle config --local path $BUNDLER_DIR && \
    bundle config --local without development:test:assets

EXPOSE 3009

CMD rm -f tmp/pids/server.pid \
  && bundle exec rails db:migrate \
  && bundle exec rails s -b 0.0.0.0 -p 3009
