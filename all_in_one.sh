#!/bin/sh
bundle exec puma -p $PORT -w 2 -t 2:8 &
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq