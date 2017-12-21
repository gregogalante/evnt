# frozen_string_literal: true

# This is an example of application that use evnt gem to work.

require_relative 'commands/create_text_file_command'

command = CreateTextFileCommand.new(name: 'foo')

if command.completed?
  puts 'File created'
else
  puts command.error_messages
end
