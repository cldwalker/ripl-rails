module Ripl::Rails::Commands
  def show_log
    change_log STDOUT
  end

  def hide_log
    change_log nil
  end

  def route
    @route ||= begin
      mod = Rails.version >= '3.0' ? Rails.application.routes.url_helpers : ActionController::UrlWriter
      klass = Class.new.send(:include, mod)
      klass.default_url_options[:host] = 'example.com'
      klass.protected_instance_methods.grep(/_url$|_path$/).each {|e| klass.send(:public, e) }
      klass.new
    end
  end

  private
  def change_log(stream, colorize=true)
    ActiveRecord::Base.logger = ::Logger.new(stream)
    ActiveRecord::Base.clear_all_connections!
    ActiveRecord::Base.colorize_logging = colorize
  end
end

Ripl::Commands.include Ripl::Rails::Commands
