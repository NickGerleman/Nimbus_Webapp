#!/bin/sh
bundle exec puma -p $PORT -t 2:8 &
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq