# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Evnt::Validator do
  it 'should have a validates function' do
    validation = Evnt::Validator.validates('string', presence: true)
    expect(validation).not_to be nil
    expect(validation).to be true
  end
end
