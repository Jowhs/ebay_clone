require 'yaml'

class App < Sinatra::Base
  register Sinatra::Flash

  set :environment, (ENV['RACK_ENV'] || :development).to_sym

  enable :method_override

  enable :sessions
  set :session_secret, '123123123123AAA123123123'

  configure :development do
    # Pass exceptions to rack
    disable :show_exceptions
    enable :raise_errors

    require 'sinatra/reloader'
    register Sinatra::Reloader

    also_reload 'models/*'
    after_reload do
      puts "Reloaded: #{Time.now}"
    end
  end

  DB = Sequel.connect(YAML.safe_load(File.open('config/database.yml'))[environment.to_s])

  # Do not throw exception is model cannot be saved. Just return nil
  Sequel::Model.raise_on_save_failure = false

  # Sequel plugins loaded by ALL models.
  Sequel::Model.plugin :validation_helpers
  Sequel::Model.plugin :dirty # http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/Dirty.html

  # load models and routes in other folders
  Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |model| require model }
  Dir[File.join(File.dirname(__FILE__), 'routes/**/*.rb')].each { |route| require route }
end
