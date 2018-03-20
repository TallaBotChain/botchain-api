FROM ruby:2.4

ENV LOG_DIR /srv/logs
ENV APP_DIR /srv/app
ENV BUNDLE_PATH /srv/bundler
ENV BUNDLE_BIN=${BUNDLE_PATH}/bin
ENV GEM_HOME=${BUNDLE_PATH}
ENV PATH="${BUNDLE_BIN}:${PATH}"

ENV SIDEKIQ_HOME=/root/botchain-sidekiq

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
        build-essential \
        libpq-dev \
        netcat \
        vim \
        less \
        curl \
	cron \
        && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p $APP_DIR $LOG_DIR $BUNDLE_PATH
WORKDIR $APP_DIR

COPY Gemfile Gemfile.lock $APP_DIR/
RUN bundle install

RUN echo "$(echo '0 1 * * * /bin/bash -l -c 'cd /src/app \&\& bin/rails runner -e production BotSyncWorker.new.perform''; crontab -l)" | crontab -
RUN echo "$(echo '0 1 * * * /bin/bash -l -c 'cd /src/app \&\& bin/rails runner -e production DeveloperRecordSyncWorker.new.perform''; crontab -l)" | crontab -

COPY . $APP_DIR/ 
ENTRYPOINT ["/srv/app/docker-entrypoint.sh"]
