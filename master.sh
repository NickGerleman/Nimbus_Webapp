bundle exec clockwork lib/clock.rb &
script/delayed_job start
bundle exec puma -p $PORT