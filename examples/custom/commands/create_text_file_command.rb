# frozen_string_literal: true

require 'evnt'
require_relative '../utils/file_system_utils'
require_relative '../events/create_file_event'

# CreateTextFileCommand.
class CreateTextFileCommand < Evnt::Command

  include FileSystemUtils

  validates :name, type: :string, presence: true, blank: false

  to_validate_params do
    # check name is valid for the file system
    err 'Name value not accepted' unless params[:name].match?(/\A[a-z0-9]+\Z/i)
  end

  to_validate_logic do
    # check no other files exists with same name
    err 'File already created' if file_exist?("#{params[:name]}.txt")
  end

  to_initialize_events do
    CreateFileEvent.new(
      file_name: params[:name],
      file_extension: 'txt'
    )
  end

end
