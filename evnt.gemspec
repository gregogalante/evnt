# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require 'evnt/version'

Gem::Specification.new do |spec|
  spec.name          = 'evnt'
  spec.version       = Evnt::VERSION
  spec.authors       = ['Ideonetwork']
  spec.email         = ['dev@ideonetwork.it']
  spec.homepage      = 'http://ideonetwork.it/'
  spec.summary       = 'CQRS and Event Driven Development architecture for Ruby'
  spec.description   = 'CQRS and Event Driven Development architecture for Ruby'
  spec.license       = 'MIT'
  spec.files         = Dir['MIT-LICENSE', 'README.md', 'lib/**/*']
  spec.require_paths = ['lib']

  # dev depenencies
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_development_dependency 'rdoc', '~> 5.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
