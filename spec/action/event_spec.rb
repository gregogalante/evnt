# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Event do
  it 'should be initialized' do
    event = Evnt::Event.new(attr1: 'foo', attr2: 'bar')
    expect(event).not_to be nil
  end
end
