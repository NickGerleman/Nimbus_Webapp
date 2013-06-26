#!/bin/sh
bundle exec puma -p $PORT -t 2:6 &
bundle exec sidekiq