# frozen_string_literal: true

##
# This example show the usage of the validation inside the command.
# Version: 2.0.2
##

require_relative './commands/validates_command'

command = ValidatesCommand.new(
  string: 'foobar',
  boolean_false: false,
  boolean_true: true
)

if command.completed?
  puts 'command completed'
else
  puts command.error_messages
end
