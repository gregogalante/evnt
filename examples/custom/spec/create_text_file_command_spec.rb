# frozen_string_literal: true

require 'rspec'
require_relative '../utils/file_system_utils'
require_relative '../commands/create_text_file_command'

RSpec.configure do |c|
  c.include FileSystemUtils
end

RSpec.describe CreateTextFileCommand do
  context 'a name parameter with an invalid value' do
    it 'should not be completed if it is nil' do
      command = CreateTextFileCommand.new(name: nil)
      expect(command.completed?).to be false
    end

    it 'should not be completed if it is empty' do
      command = CreateTextFileCommand.new(name: '')
      expect(command.completed?).to be false
    end

    it 'should not be completed if it has a strange value' do
      command = CreateTextFileCommand.new(name: 'foo bar')
      expect(command.completed?).to be false
    end

    it 'should return a correct error message' do
      command = CreateTextFileCommand.new(name: nil)
      expect(command.error_messages.first).to eq 'Name value not accepted'
      command = CreateTextFileCommand.new(name: '')
      expect(command.error_messages.first).to eq 'Name value not accepted'
      command = CreateTextFileCommand.new(name: 'foo bar')
      expect(command.error_messages.first).to eq 'Name value not accepted'
    end
  end

  context 'a name of an already existing file' do
    it 'should not be completed' do
      create_file('tmp.txt')
      command = CreateTextFileCommand.new(name: 'tmp')
      expect(command.completed?).to be false
      remove_file('tmp.txt')
    end

    it 'should return a correct error message' do
      create_file('tmp.txt')
      command = CreateTextFileCommand.new(name: 'tmp')
      expect(command.error_messages.first).to eq 'File already created'
      remove_file('tmp.txt')
    end
  end
end
