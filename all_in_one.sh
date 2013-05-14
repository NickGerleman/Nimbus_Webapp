bundle exec puma -p $PORT &
sleep 10
bundle exec clockwork lib/clock.rb &
bundle exec sidekiq