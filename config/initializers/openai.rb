OpenAI.configure do |config|
  config.access_token = ENV["OPENROUTER_ACCESS_TOKEN"] || "temporary_dummy_token"
end
