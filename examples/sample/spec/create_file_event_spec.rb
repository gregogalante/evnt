# frozen_string_literal: true

require 'rspec'
require_relative '../events/create_file_event'

RSpec.describe CreateFileEvent do
  context 'a parameter is not present' do
    it 'should raise an error' do
      begin
        CreateFileEvent.new(name: 'foo')
        expect(true).to be false
      rescue StandardError
        expect(true).to be true
      end
    end
  end
end
