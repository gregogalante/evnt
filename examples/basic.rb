# frozen_string_literal: true

##
# This example show a basic usage of the Evnt gem.
# Version: 2.0.2
##

require_relative './commands/basic_command'

# initialize command.
command = BasicCommand.new(name: 'foobar')

# check command completed.
if command.completed?
  puts 'command completed'
else
  puts command.error_messages
end
