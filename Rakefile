#Rakefile
require 'sinatra/activerecord'
require "sinatra/activerecord/rake"

namespace :db do
  task :load_config do
    require "./cookapp.rb"
  end
end

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/cookapp.sqlite3')