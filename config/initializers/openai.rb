OpenAI.configure do |config|
 config.access_token = ENV.fetch("OPENROUTER_ACCESS_TOKEN")
end
