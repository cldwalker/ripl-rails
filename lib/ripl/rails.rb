require 'ripl'
require 'pathname'

module Ripl
  module Rails
    VERSION = '0.1.1'

    class << self # inspired by the Rails 3 source
      def find_rails_root!
        cwd = Dir.pwd
        return false unless in_rails_application? || in_rails_application_subdirectory?
        return true if in_rails_application?
        Dir.chdir '..'
        find_rails_root! unless cwd == Dir.pwd
      rescue SystemCallError
        return false # could not chdir
      end

      def in_rails_application?
        File.exists?(File.join [Dir.pwd, 'config', 'boot.rb'])
      end

      def in_rails_application_subdirectory?(path = Pathname.new(Dir.pwd))
        File.exists?(File.join [path, 'config', 'boot.rb']) || !path.root? && in_rails_application_subdirectory?(path.parent)
      end
    end

    def before_loop
      if Ripl::Rails.find_rails_root!
        load_rails
        super
      else
        abort "Not in a Rails environment" unless File.exists?("#{Dir.pwd}/config/boot.rb")
      end
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
