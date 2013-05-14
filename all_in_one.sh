bundle exec puma -p $PORT &
sleep 30
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq