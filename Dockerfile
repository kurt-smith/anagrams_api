# Find the latest compatible Ruby Alpine packages at:
# https://pkgs.alpinelinux.org/packages?name=ruby&branch=v3.7
#

FROM alpine:3.7
LABEL maintainer="hire@kurtsmith.me"

ENV APP_HOME="/app" \
    GEMS="/usr/local/bundle" \
    ENTRY_POINT_DIR="docker-entrypoint-init.d" \
    RUBY_PACKAGES="ruby ruby-rdoc ruby-irb ruby-io-console ruby-json yaml ruby-rake ruby-bigdecimal nodejs" \
    DEV_PACKAGES="zlib-dev ruby-dev libxml2-dev libxslt-dev tzdata yaml-dev libstdc++ bash ca-certificates" \
    BUILD_PACKAGES="build-base openssl-dev libc-dev linux-headers git"

RUN apk update && apk --update add $DEV_PACKAGES $RUBY_PACKAGES

ADD Gemfile $GEMS/
ADD Gemfile.lock $GEMS/
WORKDIR $GEMS

RUN apk --update add --virtual build-dependencies $BUILD_PACKAGES && \
    gem install bundler && \
    bundle install --jobs=4 && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME

EXPOSE 3000

CMD ["rails", "s", "-p", "3000", "-b", "0.0.0.0"]
