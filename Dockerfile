FROM ruby:3.2.2-bookworm

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    zlib1g \
    pkg-config \
    nodejs \
    lsb-release \
    libpq-dev \
    libcurl4-openssl-dev \
    wget \
    ca-certificates \
    cron \
    vim \
    htop \
    openssh-client \
    git \
    redis-tools \
    build-essential \
    gnupg \
    libjemalloc2

ENV LD_PRELOAD="libjemalloc.so.2" \
    MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true,stats_print:false"

WORKDIR /app
COPY Gemfile* .
RUN --mount=type=ssh bundle install
COPY . .

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
