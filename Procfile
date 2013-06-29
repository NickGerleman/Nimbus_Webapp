redis: redis-server
clock: bundle exec clockwork lib/clock.rb
worker: bundle exec sidekiq
web: bundle exec puma -p 3000 -w 2 -t 1:8