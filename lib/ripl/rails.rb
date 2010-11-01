module Ripl
  module Rails
    VERSION = '0.1.0'

    def before_loop
      load_rails
      super
    end

    def load_rails
      abort "Not in a Rails environment" unless File.exists?("#{Dir.pwd}/config/boot.rb")
      ENV['RAILS_ENV'] = ARGV[0] if ARGV[0]

      require "#{Dir.pwd}/config/boot"
      require 'rails' unless defined? ::Rails
      if ::Rails.version >= '3.0'
        Object.const_set :APP_PATH, File.expand_path("#{Dir.pwd}/config/application")
        require 'rails/commands/console'
        require APP_PATH
        ::Rails.application.require_environment!
      else
        ["#{Dir.pwd}/config/environment", 'console_app', 'console_with_helpers'].each {|e| require e }
      end
      puts "Loading #{::Rails.env} environment (Rails #{::Rails.version})"
    end
  end
end

Ripl::Shell.send :include, Ripl::Rails if defined? Ripl::Shell
