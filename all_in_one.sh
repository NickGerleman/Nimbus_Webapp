bundle exec puma -p $PORT &
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq