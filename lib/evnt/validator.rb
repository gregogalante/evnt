# frozen_string_literal: true

module Evnt

  ##
  # Validator is a class used to validates params and attributes automatically.
  ##
  class Validator

    class << self

      def validates(_value, _options)
        true
      end

    end

  end

end
