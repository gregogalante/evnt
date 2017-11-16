# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Event do
  parameters = { attr1: 'foo', attr2: 'bar', _extra1: 'yuppy' }
  event = Evnt::Event.new(parameters)

  it 'should be initialized' do
    expect(event).not_to be nil
  end

  it 'should have a reloaded? function' do
    expect(event.reloaded?).not_to be nil
    expect(event.reloaded?).to be_a FalseClass
  end

  it 'should return the payload' do
    expect(event.payload).not_to be nil
    expect(event.payload[:attr1]).to be parameters[:attr1]
  end

  it 'should return the extra parameters' do
    expect(event.extras).not_to be nil
    expect(event.extras[:extra1]).to be parameters[:_extra1]
  end

  it 'should not return extra parameters as payload' do
    expect(event.payload[:_extra1]).to be nil
    expect(event.payload[:extra1]).to be nil
  end

  it 'should not return extra parameters as payload' do
    expect(event.payload[:_extra1]).to be nil
    expect(event.payload[:extra1]).to be nil
  end
end
