# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Action do
  it 'should be initialized' do
    action = Evnt::Action.new(attr1: 'foo', attr2: 'bar')
    expect(action).not_to be nil
  end
end
