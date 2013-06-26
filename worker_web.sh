#!/bin/sh
bundle exec puma -p $PORT -t 2:8 &
bundle exec sidekiq