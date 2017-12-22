# frozen_string_literal: true

require 'rspec'
require_relative '../utils/file_system_utils'
require_relative '../events/create_file_event'
require_relative '../handlers/file_system_handler'

handler = FileSystemHandler.new
event = CreateFileEvent.new(file_name: 'foo', file_extension: 'txt')

RSpec.configure do |c|
  c.include FileSystemUtils
end

RSpec.describe FileSystemHandler do
  context 'create_file event' do
    it 'should write a file with the event file name' do
      handler.notify(event)
      expect(file_exist?('foo.txt')).to be true
      remove_file('foo.txt')
    end
  end
end
