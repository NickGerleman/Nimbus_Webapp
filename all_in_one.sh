#!/bin/sh
bundle exec puma -p $PORT -w 3 -t 1:2 &
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq