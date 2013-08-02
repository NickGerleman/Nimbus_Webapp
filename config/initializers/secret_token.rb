if ENV['SECRET_TOKEN'].nil?
  NimbusWebapp::Application.config.secret_key_base =
      # This is not the one used in production
      '183670b5a08e9063b7717a2fb38dd214544dc8eb9e936cca182c30b8719cf39032cc62eb717207db961a9cf25bfc06e9afd7ee58ccea4d8753ab79796692c1ec'
else
  NimbusWebapp::Application.config.secret_key_base = ENV['SECRET_TOKEN']
end