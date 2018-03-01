# frozen_string_literal: true

require 'spec_helper'

class SuperEvent < Evnt::Event

  attributes_are :attr1

end

class MyEvent < SuperEvent

  attributes_are :attr1, :attr2

end

RSpec.describe Evnt::Event do
  parameters = { attr1: 'foo', attr2: 'bar', _extra1: 'yuppy' }
  event = MyEvent.new(parameters)

  it 'should be initialized' do
    expect(event).not_to eq nil
  end

  it 'should have a reloaded? function' do
    expect(event.reloaded?).not_to eq nil
    expect(event.reloaded?).to be_a FalseClass
  end

  it 'should return the payload' do
    expect(event.payload).not_to eq nil
    expect(event.payload[:attr1]).to eq parameters[:attr1]
  end

  it 'should return the extra parameters' do
    expect(event.extras).not_to eq nil
    expect(event.extras[:extra1]).to eq parameters[:_extra1]
  end

  it 'should not return extra parameters as payload' do
    expect(event.payload[:_extra1]).to eq nil
    expect(event.payload[:extra1]).to eq nil
  end

  it 'should not return extra parameters as payload' do
    expect(event.payload[:_extra1]).to eq nil
    expect(event.payload[:extra1]).to eq nil
  end
end
