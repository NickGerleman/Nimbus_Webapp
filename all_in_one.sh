#!/bin/sh
bundle exec puma -p $PORT -t 2:4 &
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq