# frozen_string_literal: true

require 'spec_helper'

##############################################################
# TEST GENERAL
##############################################################

class SuperEvent < Evnt::Event

  payload_attributes_are :attr1

end

class MyEvent < SuperEvent

  payload_attributes_are :attr1, :attr2

end

RSpec.describe Evnt::Event do
  parameters = { attr1: 'foo', attr2: 'bar', _extra1: 'yuppy' }
  event = MyEvent.new(parameters)

  it 'should be initialized' do
    expect(event).not_to eq nil
  end

  it 'should have a saved? function' do
    expect(event.saved?).not_to eq nil
    expect(event.saved?).to be_a TrueClass
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

  it 'should return the attributes' do
    expect(event.payload_attributes).not_to eq nil
    expect(event.payload_attributes.length).to eq 2
  end
end

##############################################################
# TEST OPTIONS AS PARAMETERS
##############################################################

class SuperEventOAP < Evnt::Event

  payload_attributes_are :attr1

end

class MyEventOAP < SuperEventOAP

  payload_attributes_are :attr1, :attr2

end

RSpec.describe Evnt::Event do
  parameters = { attr1: 'foo', attr2: 'bar', _options: { silent: true } }
  event = MyEventOAP.new(parameters)

  it 'should be initialized' do
    expect(event).not_to eq nil
  end

  it 'should not have options as payload attribute' do
    expect(event.payload).not_to eq nil
    expect(event.payload[:options]).to eq nil
  end

  it 'should not have options as extras attribute' do
    expect(event.extras).not_to eq nil
    expect(event.extras[:options]).to eq nil
  end

end

##############################################################
# TEST PRE 3.6.3 (check deprecated functions attributes works)
##############################################################

class SuperEventOld < Evnt::Event

  attributes_are :attr1

end

class MyEventOld < SuperEventOld

  attributes_are :attr1, :attr2

end

RSpec.describe Evnt::Event do
  parameters = { attr1: 'foo', attr2: 'bar', _extra1: 'yuppy' }
  event = MyEventOld.new(parameters)

  it 'should return the attributes' do
    expect(event.attributes).not_to eq nil
    expect(event.attributes.length).to eq event.payload_attributes.length
  end
end
