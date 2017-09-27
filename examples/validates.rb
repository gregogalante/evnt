# frozen_string_literal: true

##
# This example show the usage of the validation inside the command.
# Version: 2.0.2
##

require_relative './commands/validates_command'

command = ValidatesCommand.new(name: 'foo', surname: 'bar')

if command.completed?
  puts 'command completed'
else
  puts 'command has errors'
end
