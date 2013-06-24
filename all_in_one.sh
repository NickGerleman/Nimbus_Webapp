#!/bin/sh
bundle exec unicorn -p $PORT -c ./config/unicorn.rb &
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq