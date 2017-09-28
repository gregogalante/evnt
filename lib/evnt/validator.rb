# frozen_string_literal: true

module Evnt

  ##
  # Validator is a class used to validates params and attributes automatically.
  ##
  class Validator

    class << self

      ##
      # This function is used to validates a parameter with some validation
      # options.
      #
      # ==== Attributes
      #
      # * +param+ - The parameter to be validated.
      # * +options+ - The list of options for the validations.
      #
      # ==== Options
      #
      # * +type+ - Symbol value used to tells the correct parameter type.
      # * +presence+ - Boolean value used to tells if the presence is required.
      ##
      def validates(param, options)
        options.each do |key, value|
          return false unless validate_option(param, key, value)
        end

        true
      end

      private

      # This function calls the correct validate function for a specific option.
      def validate_option(param, key, value)
        case key
        when :type
          validate_type(param, value) 
        when :presence
          validate_presence(param, value)
        else
          true
        end
      end

      # This function validates the presence of the prameter.
      def validate_presence(param, value)
        # avoid presence check if value is not true
        return true unless value

        # check param is not nil
        return false if param.nil?
        # check param not empty
        return false if !validate_type_boolean(param) && param.empty?

        true
      end

      # This function validates the type of the parameter.
      def validate_type(param, value)
        case value
        when :boolean
          validate_type_boolean(param)
        when :string
          validate_type_string(param)
        else
          true
        end
      end

      def validate_type_boolean(param)
        param.instance_of?(TrueClass) || param.instance_of?(FalseClass)
      end

      def validate_type_string(param)
        param.instance_of?(String)
      end

    end

  end

end
