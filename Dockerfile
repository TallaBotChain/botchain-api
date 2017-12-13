FROM ruby:2.4

ENV LOG_DIR /srv/logs
ENV APP_DIR /srv/app
ENV BUNDLE_PATH /srv/bundler
ENV BUNDLE_BIN=${BUNDLE_PATH}/bin
ENV GEM_HOME=${BUNDLE_PATH}
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
        build-essential \
        libpq-dev \
        netcat \
        vim \
        less \
        curl \
        && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p $APP_DIR $LOG_DIR $BUNDLE_PATH
WORKDIR $APP_DIR

COPY Gemfile Gemfile.lock $APP_DIR/
RUN bundle install

COPY . $APP_DIR/

ENTRYPOINT ["/srv/app/docker-entrypoint.sh"]
