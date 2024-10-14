Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:1000/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:1000/0' }
end