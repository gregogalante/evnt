# frozen_string_literal: true

require_relative 'commands/create_text_file_command'
require_relative 'events/create_file_event'
require_relative 'handlers/file_system_handler'

FileSystemHandler.listen(CreateFileEvent)

command = CreateTextFileCommand.new(name: 'foo')

if command.completed?
  puts 'File created'
else
  puts command.error_messages
end
