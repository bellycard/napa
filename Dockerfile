FROM ruby:2.0.0-p643

# Install deps
RUN apt-get update \
  && apt-get install -y libreadline-dev nano vim \
  && apt-get purge -y --auto-remove

# Ensure Gemfile.lock is up to date
RUN bundle config --global frozen 1

# Install latest released Napa to get baseline dependencies
RUN gem install napa

# Add a simple Procfile parser
ADD contrib/start.rb /start

# Create directory for app
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy Gemfile and Gemfile.lock and run bundle install
ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD RUN bundle install

# Copy rest of app
ONBUILD COPY . /usr/src/app

CMD ["/start", "web"]
