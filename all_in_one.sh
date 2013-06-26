#!/bin/sh
bundle exec puma -p $PORT -t 8:8 &
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq