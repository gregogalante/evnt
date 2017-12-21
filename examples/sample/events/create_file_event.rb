# frozen_string_literal: true

require 'evnt'

# CreateFileEvent.
class CreateFileEvent < Evnt::Event

  name_is :create_file

  attributes_are :file_name, :file_extension

end
