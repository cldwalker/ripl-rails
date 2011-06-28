require 'ripl'
require 'pathname'

module Ripl::Rails
  VERSION = '0.1.3'

  def self.find_rails_root!
    until Pathname.pwd.join('config', 'boot.rb').exist?
      abort "Not in a Rails environment" if Pathname.pwd.root?
      Dir.chdir '..'
    end
  end

  def self.load_rails
    ENV['RAILS_ENV'] = ARGV[0] if ARGV[0].to_s[/^[^-]/]

    require "#{Dir.pwd}/config/boot"
    if File.exists?("#{Dir.pwd}/config/application.rb")
      Object.const_set :APP_PATH, File.expand_path("#{Dir.pwd}/config/application")
      require APP_PATH
      require 'rails/console/app'
      require 'rails/console/helpers'
      ::Rails.application.require_environment!
    else
      ["#{Dir.pwd}/config/environment", 'console_app', 'console_with_helpers'].each {|e| require e }
    end
    puts "Loading #{::Rails.env} environment (Rails #{::Rails.version})"
  end

  def before_loop
    Ripl::Rails.find_rails_root!
    Ripl::Rails.load_rails
    super
  end
end

Ripl::Shell.include Ripl::Rails
