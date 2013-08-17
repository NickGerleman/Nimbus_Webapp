redis: redis-server --save 0
clock: bundle exec clockwork lib/clock.rb
worker: bundle exec sidekiq
web: bundle exec unicorn -c ./config/unicorn.rb -p 3000
faye: node ./faye/app.js
