# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/ripl/rails"
 
Gem::Specification.new do |s|
  s.name        = "ripl-rails"
  s.version     = Ripl::Rails::VERSION
  s.authors     = ["Gabriel Horner"]
  s.email       = "gabriel.horner@gmail.com"
  s.homepage    = "http://github/com/cldwalker/ripl-rails"
  s.summary = "Alternative to script/console using ripl"
  s.description =  "TODO"
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = 'tagaholic'
  s.executables = ['ripl-rails']
  s.add_dependency 'ripl', '>= 0.1.2'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.license = 'MIT'
end
