#!/bin/sh
bundle exec puma -p $PORT -w 3 -t 0:4 &
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq