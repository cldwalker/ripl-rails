require 'ripl'
require 'pathname'

module Ripl
  module Rails
    VERSION = '0.1.1'

    def self.find_rails_root!
      until Pathname.pwd.join('config', 'boot.rb').exist?
        abort "Not in a Rails environment" if Pathname.pwd.root?
        Dir.chdir '..'
      end
    end

    def before_loop
      Ripl::Rails.find_rails_root!
      load_rails
      super
    end

    def load_rails
      ENV['RAILS_ENV'] = ARGV[0] if ARGV[0].to_s[/^[^-]/]

      require "#{Dir.pwd}/config/boot"
      require 'rails' unless defined? ::Rails
      if ::Rails.version >= '3.0'
        Object.const_set :APP_PATH, File.expand_path("#{Dir.pwd}/config/application")
        require 'rails/console/app'
        require 'rails/console/helpers'
        require APP_PATH
        ::Rails.application.require_environment!
      else
        ["#{Dir.pwd}/config/environment", 'console_app', 'console_with_helpers'].each {|e| require e }
      end
      puts "Loading #{::Rails.env} environment (Rails #{::Rails.version})"
    end
  end
end

Ripl::Shell.include Ripl::Rails
