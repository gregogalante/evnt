# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Command do
  it 'should be initialized' do
    command = Evnt::Command.new(attr1: 'foo', attr2: 'bar')
    expect(command).not_to be nil
  end
end
