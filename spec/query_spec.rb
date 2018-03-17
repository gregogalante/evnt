# frozen_string_literal: true

require 'spec_helper'

class SuperQuery < Evnt::Query
end

RSpec.describe Evnt::Query do
  it 'should not be initialized' do
    begin
      SuperQuery.new
      expect(true).to eq false
    rescue SystemCallError
      expect(true).to eq true
    end
  end
end
