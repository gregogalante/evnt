# frozen_string_literal: true

# Add tasks support for rails applications
Dir['tasks/**/*.rake'].each { |ext| load ext } if defined?(Rake)

require 'evnt/version'
require 'evnt/action'
require 'evnt/event'
require 'evnt/handler'

# Evnt.
module Evnt; end
