require 'connection_pool'

conf_file = File.join('config','redis.yml')
Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) do
  if File.exists?(conf_file)
    conf = YAML.load(File.read(conf_file))
    conf[Rails.env.to_s].blank? ? Redis.new : Redis.new(conf[Rails.env.to_s])
  else
    Redis.new
  end
end
