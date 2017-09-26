# frozen_string_literal: true

require 'evnt'
require_relative '../handlers/basic_handler'

# BasicEvent.
class BasicEvent < Evnt::Event

  name_is :basic

  attributes_are :name

  handlers_are [
    BasicHandler.new
  ]

  to_write_event do
    puts "#{name} saved!"
  end

end
