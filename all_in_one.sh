#!/bin/sh
bin/start-nginx
bundle exec unicorn -c config/unicorn.rb &
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq