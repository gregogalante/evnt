# frozen_string_literal: true

require 'rspec'
require_relative '../events/create_file_event'

RSpec.describe CreateFileEvent do
  context 'a parameter is not present' do
    it 'should raise an error with a correct error message' do
      begin
        CreateFileEvent.new(file_name: 'foo')
        expect(true).to be false
      rescue StandardError => e
        expect(true).to be true
        expect(e.to_s).to eq 'Event parameters are not correct'
      end
    end
  end

  context 'a paremeter that not exist' do
    it 'should raise an error with a correct error message' do
      begin
        CreateFileEvent.new(file_name: 'foo', file_extension: 'txt', custom: 'true')
        expect(true).to be false
      rescue StandardError => e
        expect(true).to be true
        expect(e.to_s).to eq 'Event parameters are not correct'
      end
    end
  end

  context 'a request of the event name' do
    it 'should return the correct event name' do
      event = CreateFileEvent.new(file_name: 'foo', file_extension: 'txt')
      expect(event.name).to eq :create_file
    end
  end
end
