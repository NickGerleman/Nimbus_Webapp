#!/bin/sh
bundle exec puma -p $PORT -t 0:4 &
bundle exec sidekiq