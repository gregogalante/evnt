# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Command do
  command = Evnt::Command.new(attr1: 'foo', attr2: 'bar')

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
