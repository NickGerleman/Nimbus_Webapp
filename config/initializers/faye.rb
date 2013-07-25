faye_options = {
  mount: '/socket',
  timeout: 25,
  engine: {
   type: Faye::Redis,
   host: URI.parse(ENV["REDIS_URL"]).host
  }
}
FAYE = Faye::RackAdapter.new(NimbusWebapp::Application, faye_options)
