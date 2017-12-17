# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Validator do
  it 'should have a validates function' do
    value = 'string'
    validation = Evnt::Validator.validates(value, presence: true)
    expect(validation).not_to be nil
  end

  # Type:
  # The type validation should check the correct variable type.
  #################################################################

  # Datetime

  it 'should accept a date value with type: datetime' do
    value = DateTime.now
    validation = Evnt::Validator.validates(value, type: :datetime)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a nil value with type: datetime' do
    value = nil
    validation = Evnt::Validator.validates(value, type: :datetime)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a string date value with type: datetime' do
    value = DateTime.now.to_s
    validation = Evnt::Validator.validates(value, type: :datetime)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq DateTime.parse(value)
  end

  it 'should not accept a not string date value with type: datetime' do
    value = 'Sambuca'
    validation = Evnt::Validator.validates(value, type: :datetime)
    expect(validation).to eq :ERROR
    expect(validation).not_to eq value
  end

  it 'should not accept a integer date value with type: datetime' do
    value = 1234
    validation = Evnt::Validator.validates(value, type: :datetime)
    expect(validation).to eq :ERROR
    expect(validation).not_to eq value
  end

  # Date

  it 'should accept a date value with type: date' do
    value = Date.today
    validation = Evnt::Validator.validates(value, type: :date)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a nil value with type: date' do
    value = nil
    validation = Evnt::Validator.validates(value, type: :date)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a string date value with type: date' do
    value = Date.today.to_s
    validation = Evnt::Validator.validates(value, type: :date)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq Date.parse(value)
  end

  it 'should not accept a not string date value with type: date' do
    value = 'Sambuca'
    validation = Evnt::Validator.validates(value, type: :date)
    expect(validation).to eq :ERROR
    expect(validation).not_to eq value
  end

  it 'should not accept a integer date value with type: date' do
    value = 1234
    validation = Evnt::Validator.validates(value, type: :date)
    expect(validation).to eq :ERROR
    expect(validation).not_to eq value
  end

  # String

  it 'should accept a string value with type: string' do
    value = 'Hello'
    validation = Evnt::Validator.validates(value, type: :string)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a nil value with type: string' do
    value = nil
    validation = Evnt::Validator.validates(value, type: :string)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a integer value with type: string' do
    value = 23
    validation = Evnt::Validator.validates(value, type: :string)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value.to_s
  end

  it 'should accept a float value with type: string' do
    value = 23.5
    validation = Evnt::Validator.validates(value, type: :string)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value.to_s
  end

  it 'should accept a boolean value with type: string' do
    value = true
    validation = Evnt::Validator.validates(value, type: :string)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value.to_s
  end

  # Integer

  it 'should accept a integer value with type: integer' do
    value = 4
    validation = Evnt::Validator.validates(value, type: :integer)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a nil value with type: integer' do
    value = nil
    validation = Evnt::Validator.validates(value, type: :integer)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a string integer value with type: integer' do
    value = '56'
    validation = Evnt::Validator.validates(value, type: :integer)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value.to_i
  end

  it 'should accept a string float value with type: integer' do
    value = '56.9'
    validation = Evnt::Validator.validates(value, type: :integer)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value.to_i
  end

  # Float

  it 'should accept a float value with type: float' do
    value = 3.15
    validation = Evnt::Validator.validates(value, type: :float)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a nil value with type: float' do
    value = nil
    validation = Evnt::Validator.validates(value, type: :float)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a string float value with type: float' do
    value = '3.25'
    validation = Evnt::Validator.validates(value, type: :float)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value.to_f
  end

  it 'should accept a string integer value with type: float' do
    value = '3'
    validation = Evnt::Validator.validates(value, type: :float)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value.to_f
  end

  # Symbol

  it 'should accept a symbol value with type: symbol' do
    value = :hello
    validation = Evnt::Validator.validates(value, type: :symbol)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a nil value with type: symbol' do
    value = nil
    validation = Evnt::Validator.validates(value, type: :symbol)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should not accept a string value with type: symbol' do
    value = 'hello'
    validation = Evnt::Validator.validates(value, type: :symbol)
    expect(validation).to eq :ERROR
    expect(validation).not_to eq value
  end

  it 'should not accept a integer value with type: symbol' do
    value = 5
    validation = Evnt::Validator.validates(value, type: :symbol)
    expect(validation).to eq :ERROR
    expect(validation).not_to eq value
  end

  # # Presence:
  # # The presence validation permit to check that a value is
  # # not nil. Every other value that is not nil should be accepted.
  # #################################################################

  it 'should not accept a nil value with presence: true' do
    value = nil
    validation = Evnt::Validator.validates(value, presence: true)
    expect(validation).to eq :ERROR
    expect(validation).not_to eq value
  end

  it 'should accept a not nil value with presence: true' do
    value = 'foo'
    validation = Evnt::Validator.validates(value, presence: true)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept an empty array value with presence: true' do
    value = []
    validation = Evnt::Validator.validates(value, presence: true)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept an empty hash value with presence: true' do
    value = {}
    validation = Evnt::Validator.validates(value, presence: true)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a false boolean value with presence: true' do
    value = false
    validation = Evnt::Validator.validates(value, presence: true)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should accept a true boolean value with presence: true' do
    value = true
    validation = Evnt::Validator.validates(value, presence: true)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should not accept an empty string value with presence: false' do
    value = ''
    validation = Evnt::Validator.validates(value, presence: false)
    expect(validation).to eq :ERROR
    expect(validation).not_to eq value
  end

  it 'should accept a nil value with presence: false' do
    value = nil
    validation = Evnt::Validator.validates(value, presence: false)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  # # Blank:
  # # The blank validation check a string is not empty.
  # #################################################################

  it 'should accept a long string value with blank: false' do
    value = 'helloworld'
    validation = Evnt::Validator.validates(value, blank: false)
    expect(validation).not_to eq :ERROR
    expect(validation).to eq value
  end

  it 'should not accept an empty string value with blank: false' do
    value = ''
    validation = Evnt::Validator.validates(value, blank: false)
    expect(validation).to eq :ERROR
    expect(validation).not_to eq value
  end

end
