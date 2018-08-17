require 'bundler/setup'
Bundler.require(:default, :test)
ENV['RACK_ENV'] = 'test'

require './app.rb'

FactoryBot.definition_file_paths = %w{./spec/factories}
FactoryBot.define do
  to_create(&:save)
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.mock_with :rspec
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
    App::DB.run('SET FOREIGN_KEY_CHECKS=0;')
    DatabaseCleaner.clean_with(:truncation)
    App::DB.run('SET FOREIGN_KEY_CHECKS=1;')
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

RSpec::Matchers.define(:redirect_to) do |url|
  match do |response|
    response.status == 302 && response.headers['Location'] == url
  end
end

# Add an app method for RSpec
def app
  App.new
end
