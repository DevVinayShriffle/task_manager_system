Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
  Rails.application.credentials.google_auth[:client_id],
  Rails.application.credentials.google_auth[:secret_id],
  {
    scope: 'email, profile',
    redirect_uri: 'http://127.0.0.1:3000/auth/google_oauth2/callback'
  }
end

OmniAuth.config.allowed_request_methods = [:post]