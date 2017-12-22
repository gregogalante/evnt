# frozen_string_literal: true

require 'evnt'
require_relative '../utils/file_system_utils'

# FileSystemHandler.
class FileSystemHandler < Evnt::Handler

  include FileSystemUtils

  on :create_file do
    to_manage_event do
      create_file("#{event.payload[:file_name]}.#{event.payload[:file_extension]}")
    end
  end

end
