# frozen_string_literal: true

require 'evnt/version'
require 'evnt/command'
require 'evnt/event'
require 'evnt/handler'
require 'evnt/validator'

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
