# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Event do
  event = Evnt::Event.new(attr1: 'foo', attr2: 'bar')

  it 'should be initialized' do
    expect(event).not_to be nil
  end

  it 'should have a reloaded? function' do
    expect(event.reloaded?).not_to be nil
    expect(event.reloaded?).to be_a FalseClass
  end
end
