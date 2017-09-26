# frozen_string_literal: true

# VERSION 2.0.2

require_relative './commands/basic_command'

command = BasicCommand.new(name: 'foobar')

if command.completed?
  puts 'command completed'
else
  puts 'command has errors'
end
