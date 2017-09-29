# frozen_string_literal: true

module Evnt

  ##
  # Validator is a class used to validates params and attributes automatically.
  ##
  class Validator

    # Class functions:
    ############################################################################

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

      ##
      # This function calls the correct validate function for a specific option.
      #
      # ==== Attributes
      #
      # * +param+ - The parameter to be validated.
      # * +option_key+ - The key of the option that should be used.
      # * +option_value+ - The value of the option that should be used.
      ##
      def validate_option(param, option_key, option_value)
        case option_key
        when :type
          validate_type(param, option_value)
        when :presence
          validate_presence(param, option_value)
        else
          raise 'Validator option not accepted'
        end
      end

      ##
      # This function validates the type of the parameter.
      #
      # ==== Attributes
      #
      # * +param+ - The parameter to be validated.
      # * +value+ - The value of the type option that should be used.
      ##
      def validate_type(param, value)
        if value.instance_of?(Symbol)
          validate_type_general(param, value)
        elsif value.instance_of?(String)
          validate_type_custom(param, value)
        else
          raise 'Validator type option not accepted'
        end
      end

      ##
      # This function validates the presence of the prameter.
      # A parameter is present when its value is not nil.
      #
      # ==== Attributes
      #
      # * +param+ - The parameter to be validated.
      # * +value+ - The value of the presence option that should be used.
      ##
      def validate_presence(param, value)
        # avoid presence check if value is not true
        return true unless value

        # check param is not nil
        return false if param.nil?

        true
      end

      # Private functions:
      ##########################################################################

      private

      # Types validations:
      ##########################################################################

      # This function validates a param type for general types.
      def validate_type_general(param, value)
        case value
        when :boolean
          validate_type_boolean(param)
        when :string
          validate_type_string(param)
        when :integer
          validate_type_integer(param)
        when :symbol
          validate_type_symbol(param)
        when :float
          validates_type_float(param)
        when :hash
          validates_type_hash(param)
        when :array
          validates_type_array(param)
        else
          raise 'Validator type option not accepted'
        end
      end

      # This function validates a param type for custom types.
      def validate_type_custom(param, value)
        param.instance_of?(Object.const_get(value))
      rescue StandardError
        false
      end

      def validate_type_boolean(param)
        param.instance_of?(TrueClass) || param.instance_of?(FalseClass)
      rescue StandardError
        false
      end

      def validate_type_string(param)
        param.instance_of?(String)
      rescue StandardError
        false
      end

      def validate_type_integer(param)
        param.instance_of?(Integer)
      rescue StandardError
        false
      end

      def validate_type_symbol(param)
        param.instance_of?(Symbol)
      rescue StandardError
        false
      end

      def validates_type_float(param)
        param.instance_of?(Float)
      rescue StandardError
        false
      end

      def validates_type_hash(param)
        param.instance_of?(Hash)
      rescue StandardError
        false
      end

      def validates_type_array(param)
        param.instance_of?(Array)
      rescue StandardError
        false
      end

    end

  end

end
