#!/bin/sh
bbin/start-nginx
bundle exec unicorn -c config/unicorn.rb &
bundle exec sidekiq