NimbusWebapp::Application.config.session_store :cookie_store, {
    key: '_session_data',
    secure: Rails.env.production?,
    expires_in: 1.hour
}