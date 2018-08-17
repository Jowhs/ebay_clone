require 'bundler/setup'
Bundler.require(:default, (ENV['RACK_ENV'] || :development).to_sym)

require 'better_errors'
use BetterErrors::Middleware

require './app'
run App
