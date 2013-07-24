settings = {
    key: '_session_data',
    secure: Rails.env.production?,
    expires_in: 1.hour
}

settings[:domain] = '.nimbuu.us' if Rails.env.production?

NimbusWebapp::Application.config.session_store :redis_store, settings
