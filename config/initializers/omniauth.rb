OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1520592868050424', '548f5a02d4dc698a5327aa1e9dc5f40b', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end