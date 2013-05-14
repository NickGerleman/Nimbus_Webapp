bundle exec clockwork lib/clock.rb &
rake jobs:work &
bundle exec puma -p $PORT