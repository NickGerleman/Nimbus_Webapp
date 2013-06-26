#!/bin/sh
bundle exec puma -p $PORT -t 8:8 &
bundle exec sidekiq