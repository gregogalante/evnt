# frozen_string_literal: true

require 'evnt'
require_relative '../handlers/file_system_handler'

# CreateFileEvent.
class CreateFileEvent < Evnt::Event

  name_is :create_file

  attributes_are :file_name, :file_extension

  to_write_event do
    # ...
  end

end
