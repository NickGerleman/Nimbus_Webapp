bundle exec clockwork lib/clock.rb &
bundle exec puma -p $PORT &
rake jobs:work