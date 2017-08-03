# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'evnt/version'

Gem::Specification.new do |spec|
  spec.name          = 'evnt'
  spec.version       = Evnt::VERSION
  spec.authors       = ['Ideonetwork']
  spec.email         = ['info@ideonetwork.it']
  spec.homepage      = 'http://naturaldesign.cc/'
  spec.summary       = 'CQRS and Event Driven Development architecture for Ruby'
  spec.description   = 'CQRS and Event Driven Development architecture for Ruby projects'
  spec.license       = 'MIT'
  spec.require_paths = ['lib', 'README.md']

  # dev depenencies
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
