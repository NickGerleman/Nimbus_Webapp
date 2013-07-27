unless ENV["REDIS_URL"].nil?
  uri = URI.parse(ENV["REDIS_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, driver: :hiredis)
end