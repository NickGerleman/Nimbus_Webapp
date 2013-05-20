#!/bin/sh
bundle exec sidekiq &
bundle exec puma -p $PORT