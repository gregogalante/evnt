# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'evnt/version'

Gem::Specification.new do |spec|
  spec.name          = 'evnt'
  spec.version       = Evnt::VERSION
  spec.authors       = ['Gregorio Galante']
  spec.email         = ['gregogalante@gmail.com']

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.require_paths = ['lib/**/*', 'Rakefile', 'README.md']

  # dev depenencies
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
