# frozen_string_literal: true

require 'spec_helper'

##############################################################
# TEST GENERAL
##############################################################

class SuperCommand < Evnt::Command
end

class MyCommand < SuperCommand

  validates :attr1, type: :string
  validates :attr2, type: :string

end

RSpec.describe Evnt::Command do
  command = MyCommand.new(attr1: 'foo', attr2: 'bar')

  it 'should be initialized' do
    expect(command).not_to eq nil
  end

  it 'should have a complete? function' do
    expect(command.completed?).not_to eq nil
    expect(command.completed?).to be_a TrueClass
  end

  it 'should have a errors function' do
    expect(command.errors).not_to eq nil
    expect(command.errors).to be_a Array
  end

  it 'should have a error_messages function' do
    expect(command.error_messages).not_to eq nil
    expect(command.error_messages).to be_a Array
  end

  it 'should have a error_codes function' do
    expect(command.error_codes).not_to eq nil
    expect(command.error_codes).to be_a Array
  end
end

##############################################################
# TEST CUSTOM VALIDATION FUNCTION
##############################################################

class MyCommandCustomValidationFunction < Evnt::Command

  validates :attr1, type: :string
  validates :attr2, type: :string, do: :validate_attribute_2

  def validate_attribute_2
    return true if params[:attr2] == 'foo'
    err('Attr2 is not bar :(', code: :attr2)
    false
  end

end

RSpec.describe Evnt::Command do
  command = MyCommandCustomValidationFunction.new(attr1: 'foo', attr2: 'bar')

  it 'should be initialized with custom validation functions' do
    expect(command).not_to eq nil
  end

  it 'shoud run custom validation functions correctly (check error)' do
    expect(command).not_to eq nil
    expect(command.completed?).not_to eq nil
    expect(command.completed?).to be_a FalseClass

    puts command.error_messages
  end

end
