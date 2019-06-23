
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "x6FX2r9rTEOTIPnHz0MnO8yBH", "GHWhSbtOfUs88r7rIkNXfkgTd5WcNMQbPOZ7B2O2iHTz6IZEl6"
  #provider :twitter, ENV['TW_APP_KEY'], ENV['TW_APP_SECRET']
  #api_key, #api_secret
end