# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Validator do
  it 'should have a validates function' do
    validation = Evnt::Validator.validates('string', presence: true)
    expect(validation).not_to be nil
    expect(validation).to be true
  end

  # Presence:
  # The presence validation permit to check that a value is
  # not nil. Every other value that is not nil should be accepted.
  #################################################################

  it 'should not accept a nil value with presence: true' do
    validation = Evnt::Validator.validates(nil, presence: true)
    expect(validation).not_to be nil
    expect(validation).to be false
  end

  it 'should accept a not nil value with presence: true' do
    validation = Evnt::Validator.validates('foo', presence: true)
    expect(validation).not_to be nil
    expect(validation).to be true
  end

  it 'should accept an empty array value with presence: true' do
    validation = Evnt::Validator.validates([], presence: true)
    expect(validation).not_to be nil
    expect(validation).to be true
  end

  it 'should accept an empty hash value with presence: true' do
    validation = Evnt::Validator.validates({}, presence: true)
    expect(validation).not_to be nil
    expect(validation).to be true
  end

  it 'should accept a false boolean value with presence: true' do
    validation = Evnt::Validator.validates(false, presence: true)
    expect(validation).not_to be nil
    expect(validation).to be true
  end

  it 'should accept a true boolean value with presence: true' do
    validation = Evnt::Validator.validates(true, presence: true)
    expect(validation).not_to be nil
    expect(validation).to be true
  end

  it 'should not accept an empty string value with presence: false' do
    validation = Evnt::Validator.validates('', presence: false)
    expect(validation).not_to be nil
    expect(validation).to be false
  end

  it 'should accept a nil value with presence: false' do
    validation = Evnt::Validator.validates(nil, presence: false)
    expect(validation).not_to be nil
    expect(validation).to be true
  end

  # Blank:
  #################################################################

  it 'should not accept an empty string value with blank: false' do
    validation = Evnt::Validator.validates('', blank: false)
    expect(validation).not_to be nil
    expect(validation).to be false
  end
end
