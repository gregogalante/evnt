# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Validator do

  # Presence:
  # The presence validation permit to check that a value is
  # not nil. Every other value that is not nil should be accepted.
  #################################################################

  it 'should not accept a nil value with presence: true' do
    value = nil
    validation = Evnt::Validator.new(value, presence: true)
    expect(validation.passed?).to eq false
  end

  it 'should accept a not nil value with presence: true' do
    value = 'foo'
    validation = Evnt::Validator.new(value, presence: true)
    expect(validation.passed?).to eq true
  end

  it 'should accept an empty array value with presence: true' do
    value = []
    validation = Evnt::Validator.new(value, presence: true)
    expect(validation.passed?).to eq true
  end

  it 'should accept an empty hash value with presence: true' do
    value = {}
    validation = Evnt::Validator.new(value, presence: true)
    expect(validation.passed?).to eq true
  end

  it 'should accept a false boolean value with presence: true' do
    value = false
    validation = Evnt::Validator.new(value, presence: true)
    expect(validation.passed?).to eq true
  end

  it 'should accept a true boolean value with presence: true' do
    value = true
    validation = Evnt::Validator.new(value, presence: true)
    expect(validation.passed?).to eq true
  end

  # Type:
  # The type validation should check the correct variable type.
  #################################################################

  # Time

  it 'should accept a date value with type: time' do
    value = Time.now
    validation = Evnt::Validator.new(value, type: :time)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a nil value with type: time' do
    value = nil
    validation = Evnt::Validator.new(value, type: :time)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a string date value with type: time' do
    value = Time.now.to_s
    validation = Evnt::Validator.new(value, type: :time)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq Time.parse(value)
  end

  it 'should not accept a not string date value with type: time' do
    value = 'Sambuca'
    validation = Evnt::Validator.new(value, type: :time)
    expect(validation.passed?).to eq false
  end

  it 'should not accept a integer date value with type: time' do
    value = 1234
    validation = Evnt::Validator.new(value, type: :time)
    expect(validation.passed?).to eq false
  end

  # Datetime

  it 'should accept a date value with type: datetime' do
    value = DateTime.now
    validation = Evnt::Validator.new(value, type: :datetime)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a nil value with type: datetime' do
    value = nil
    validation = Evnt::Validator.new(value, type: :datetime)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a string date value with type: datetime' do
    value = DateTime.now.to_s
    validation = Evnt::Validator.new(value, type: :datetime)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq DateTime.parse(value)
  end

  it 'should not accept a not string date value with type: datetime' do
    value = 'Sambuca'
    validation = Evnt::Validator.new(value, type: :datetime)
    expect(validation.passed?).to eq false
  end

  it 'should not accept a integer date value with type: datetime' do
    value = 1234
    validation = Evnt::Validator.new(value, type: :datetime)
    expect(validation.passed?).to eq false
  end

  # Date

  it 'should accept a date value with type: date' do
    value = Date.today
    validation = Evnt::Validator.new(value, type: :date)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a nil value with type: date' do
    value = nil
    validation = Evnt::Validator.new(value, type: :date)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a string date value with type: date' do
    value = Date.today.to_s
    validation = Evnt::Validator.new(value, type: :date)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq Date.parse(value)
  end

  it 'should not accept a not string date value with type: date' do
    value = 'Sambuca'
    validation = Evnt::Validator.new(value, type: :date)
    expect(validation.passed?).to eq false
  end

  it 'should not accept a integer date value with type: date' do
    value = 1234
    validation = Evnt::Validator.new(value, type: :date)
    expect(validation.passed?).to eq false
  end

  # String

  it 'should accept a string value with type: string' do
    value = 'Hello'
    validation = Evnt::Validator.new(value, type: :string)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a nil value with type: string' do
    value = nil
    validation = Evnt::Validator.new(value, type: :string)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a integer value with type: string' do
    value = 23
    validation = Evnt::Validator.new(value, type: :string)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value.to_s
  end

  it 'should accept a float value with type: string' do
    value = 23.5
    validation = Evnt::Validator.new(value, type: :string)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value.to_s
  end

  it 'should accept a boolean value with type: string' do
    value = true
    validation = Evnt::Validator.new(value, type: :string)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value.to_s
  end

  # Integer

  it 'should accept a integer value with type: integer' do
    value = 4
    validation = Evnt::Validator.new(value, type: :integer)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a nil value with type: integer' do
    value = nil
    validation = Evnt::Validator.new(value, type: :integer)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a string integer value with type: integer' do
    value = '56'
    validation = Evnt::Validator.new(value, type: :integer)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value.to_i
  end

  it 'should accept a string float value with type: integer' do
    value = '56.9'
    validation = Evnt::Validator.new(value, type: :integer)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value.to_i
  end

  # Float

  it 'should accept a float value with type: float' do
    value = 3.15
    validation = Evnt::Validator.new(value, type: :float)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a nil value with type: float' do
    value = nil
    validation = Evnt::Validator.new(value, type: :float)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a string float value with type: float' do
    value = '3.25'
    validation = Evnt::Validator.new(value, type: :float)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value.to_f
  end

  it 'should accept a string integer value with type: float' do
    value = '3'
    validation = Evnt::Validator.new(value, type: :float)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value.to_f
  end

  # Symbol

  it 'should accept a symbol value with type: symbol' do
    value = :hello
    validation = Evnt::Validator.new(value, type: :symbol)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should accept a nil value with type: symbol' do
    value = nil
    validation = Evnt::Validator.new(value, type: :symbol)
    expect(validation.passed?).to eq true
    expect(validation.value).to eq value
  end

  it 'should not accept a string value with type: symbol' do
    value = 'hello'
    validation = Evnt::Validator.new(value, type: :symbol)
    expect(validation.passed?).to eq false
  end

  it 'should not accept a integer value with type: symbol' do
    value = 5
    validation = Evnt::Validator.new(value, type: :symbol)
    expect(validation.passed?).to eq false
  end

  # Global:
  #################################################################

  it 'should should not accept a value not equal to the equal option' do
    value = 1
    validation = Evnt::Validator.new(value, type: :integer, equal: 2)
    expect(validation.passed?).to eq false
  end

  it 'should should accept a value equal to the equal option' do
    value = 2
    validation = Evnt::Validator.new(value, type: :integer, equal: 2)
    expect(validation.passed?).to eq true
  end

  it 'should should not accept a value not included in the in option values' do
    value = 1
    validation = Evnt::Validator.new(value, type: :integer, in: [2, 3, 4])
    expect(validation.passed?).to eq false
  end

  it 'should should accept a value included in the in option values' do
    value = 1
    validation = Evnt::Validator.new(value, type: :integer, in: [1, 2, 3, 4])
    expect(validation.passed?).to eq true
  end

  it 'should should not accept a value included in the out option values' do
    value = 2
    validation = Evnt::Validator.new(value, type: :integer, out: [2, 3, 4])
    expect(validation.passed?).to eq false
  end

  it 'should should accept a value not included in the out option values' do
    value = 1
    validation = Evnt::Validator.new(value, type: :integer, out: [2, 3, 4])
    expect(validation.passed?).to eq true
  end

  # String:
  #################################################################

  it 'it should not accept an empty string with blank option false' do
    value = ''
    validation = Evnt::Validator.new(value, type: :string, blank: false)
    expect(validation.passed?).to eq false
  end

  it 'it should accept an empty string with blank option true' do
    value = ''
    validation = Evnt::Validator.new(value, type: :string, blank: true)
    expect(validation.passed?).to eq true
  end

  it 'it should not accept a not empty string with blank option true' do
    value = 'hello'
    validation = Evnt::Validator.new(value, type: :string, blank: true)
    expect(validation.passed?).to eq false
  end

  it 'it should accept a not empty string with blank option false' do
    value = 'hello'
    validation = Evnt::Validator.new(value, type: :string, blank: false)
    expect(validation.passed?).to eq true
  end

  it 'it should accept a string with same length as length option' do
    value = 'hello'
    validation = Evnt::Validator.new(value, type: :string, length: value.length)
    expect(validation.passed?).to eq true
  end

  it 'it should accept a string with length equal or more than min length option' do
    value = 'hello'
    validation = Evnt::Validator.new(value, type: :string, min_length: value.length - 1)
    expect(validation.passed?).to eq true
  end

  it 'it should not accept a string with length less than min length option' do
    value = 'hello'
    validation = Evnt::Validator.new(value, type: :string, min_length: value.length + 1)
    expect(validation.passed?).to eq false
  end

  it 'it should accept a string with length equal or less than max length option' do
    value = 'hello'
    validation = Evnt::Validator.new(value, type: :string, max_length: value.length + 1)
    expect(validation.passed?).to eq true
  end

  it 'it should not accept a string with length more than mac length option' do
    value = 'hello'
    validation = Evnt::Validator.new(value, type: :string, max_length: value.length - 1)
    expect(validation.passed?).to eq false
  end

  it 'it should not accept a string with different length than length option' do
    value = 'hello'
    validation = Evnt::Validator.new(value, type: :string, length: value.length + 1)
    expect(validation.passed?).to eq false
  end

  it 'it should not accept a string that not match the regex option' do
    value = 'hello'
    validation = Evnt::Validator.new(value, type: :string, regex: /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,20}$/)
    expect(validation.passed?).to eq false
  end

  it 'it should accept a string that match the regex option' do
    value = 'Hello1'
    validation = Evnt::Validator.new(value, type: :string, regex: /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,20}$/)
    expect(validation.passed?).to eq true
  end

  # Number:
  #################################################################

  it 'it should not accept a value minor than min option' do
    value = 5
    validation = Evnt::Validator.new(value, type: :integer, min: 10)
    expect(validation.passed?).to eq false
  end

  it 'it should accept a value plus than min option' do
    value = 5
    validation = Evnt::Validator.new(value, type: :integer, min: 4)
    expect(validation.passed?).to eq true
  end

  it 'it should not accept a value plus than max option' do
    value = 5
    validation = Evnt::Validator.new(value, type: :integer, max: 4)
    expect(validation.passed?).to eq false
  end

  it 'it should accept a value minor than max option' do
    value = 5
    validation = Evnt::Validator.new(value, type: :integer, max: 6)
    expect(validation.passed?).to eq true
  end

  # Time:
  #################################################################

  it 'it should not accept a date less than min option' do
    value = Date.today
    validation = Evnt::Validator.new(value, type: :date, min: Date.today + 1)
    expect(validation.passed?).to eq false
  end

  it 'it should accept a date more than min option' do
    value = Date.today
    validation = Evnt::Validator.new(value, type: :date, min: Date.today - 1)
    expect(validation.passed?).to eq true
  end

  it 'it should not accept a date more than max option' do
    value = Date.today
    validation = Evnt::Validator.new(value, type: :date, max: Date.today - 1)
    expect(validation.passed?).to eq false
  end

  it 'it should accept a date less than max option' do
    value = Date.today
    validation = Evnt::Validator.new(value, type: :date, max: Date.today + 1)
    expect(validation.passed?).to eq true
  end

end
