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
        result = param
        options.each do |key, value|
          result = validate_option(param, key, value)
          break if result == :ERROR
        end

        result
      rescue StandardError => e
        puts e
        :ERROR
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
        when :blank
          validate_blank(param, option_value)
        else
          raise 'Validator option not accepted'
        end
      rescue StandardError => e
        puts e
        :ERROR
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
        return param if param.nil?

        if value.instance_of?(Symbol)
          validate_type_general(param, value)
        elsif value.instance_of?(String)
          validate_type_custom(param, value)
        else
          raise 'Validator type option not accepted'
        end
      rescue StandardError => e
        puts e
        :ERROR
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
        is_nil = param.nil?
        result = value ? !is_nil : is_nil
        return param if result

        :ERROR
      rescue StandardError => e
        puts e
        :ERROR
      end

      ##
      # This function validates the blank of the prameter.
      # A parameter is blank when its value is nil, false, or empty.
      #
      # ==== Attributes
      #
      # * +param+ - The parameter to be validated.
      # * +value+ - The value of the presence option that should be used.
      ##
      def validate_blank(param, value)
        blank = (!param || param.empty?)
        result = value ? blank : !blank
        return param if result

        :ERROR
      rescue StandardError => e
        puts e
        :ERROR
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
        when :date
          validates_type_date(param)
        when :datetime
          validates_type_datetime(param)
        else
          raise 'Validator type option not accepted'
        end
      end

      # This function validates a param type for custom types.
      def validate_type_custom(param, value)
        return param if param.instance_of?(Object.const_get(value))
        :ERROR
      end

      def validate_type_symbol(param)
        return param if param.instance_of?(Symbol)
        :ERROR
      end

      def validate_type_boolean(param)
        return param if param.instance_of?(TrueClass) || param.instance_of?(FalseClass)
        return true if [1, 'true'].include? param
        return false if [0, 'false'].include? param
        :ERROR
      end

      def validate_type_integer(param)
        return param if param.instance_of?(Integer)
        begin
          return param.to_i
        rescue StandardError
          return :ERROR
        end
      end

      def validates_type_float(param)
        return param if param.instance_of?(Float)
        begin
          return param.to_f
        rescue StandardError
          return :ERROR
        end
      end

      def validate_type_string(param)
        return param if param.instance_of?(String)
        begin
          return param.to_s
        rescue StandardError
          return :ERROR
        end
      end

      def validates_type_date(param)
        return param if param.instance_of?(Date)
        begin
          return Date.parse(param)
        rescue StandardError
          return :ERROR
        end
      end

      def validates_type_datetime(param)
        return param if param.instance_of?(DateTime)
        begin
          return DateTime.parse(param)
        rescue StandardError
          return :ERROR
        end
      end

      def validates_type_hash(param)
        return param if param.instance_of?(Hash)
        :ERROR
      end

      def validates_type_array(param)
        return param if param.instance_of?(Array)
        :ERROR
      end

    end

  end

end
