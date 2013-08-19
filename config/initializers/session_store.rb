settings = {
    key: '_session_data',
    expires_in: 1.hour
}

settings[:domain] = ".#{ENV['HOST']}" if Rails.env.production?

NimbusWebapp::Application.config.session_store :redis_store, settings
