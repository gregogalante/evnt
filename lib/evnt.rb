# frozen_string_literal: true

require_relative 'evnt/version'
require_relative 'evnt/command'
require_relative 'evnt/event'
require_relative 'evnt/handler'
require_relative 'evnt/validator'

##
# Evnt is a gem developed to integrate a event driven development
# and CQRS pattern inside a ruby project.
# Evnt is developed to be used over all kinds of projects and
# frameworks (like Ruby on Rails or Sinatra), so it contains
# only three types of entities:
#
# - Command
# - Event
# - Handler
##
module Evnt; end
