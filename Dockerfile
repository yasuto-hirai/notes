FROM ruby:3.0-buster

ENV TZ Asia/Tokyo
ENV APP_NAME notes
ENV APP_ROOT /${APP_NAME}
ENV APP_USER ${APP_NAME}
ENV APP_UID 1000

RUN apt-get update -qq && apt-get install -y build-essential && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && \
  apt-get install -y nodejs yarn && \
  yarn && \
  apt-get clean && \
  rm --recursive --force /var/lib/apt/lists/*

RUN echo root:root | chpasswd

RUN groupadd -g ${APP_UID} ${APP_USER}
RUN useradd -d ${APP_ROOT} ${APP_USER} -u ${APP_UID} -g ${APP_USER} -s /bin/bash -k /etc/skel -m

WORKDIR ${APP_ROOT}

ADD . ${APP_ROOT}

RUN bundle install

USER ${APP_USER}

CMD sleep infinity
