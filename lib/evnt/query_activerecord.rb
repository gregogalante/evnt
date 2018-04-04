# frozen_string_literal: true

module Evnt

  ##
  # Queries are used to read and prepare data from the database
  # to the client.
  # The QueryActivercord class shuld contain helpers used to develop custom
  # queries based on activerecord.
  ##
  class QueryActiverecord < Evnt::Query

    ##
    # This function should run a query and return the result as a hash/json object.
    #
    # ==== Attributes
    #
    # * +query+ - The name of the query that should be executed.
    # * +parameters+ - An object containing the parameters for the query.
    ##
    def self.as_json(query, parameters = {})
      except = parameters[:_except] || []
      only = parameters[:_only] || []

      result = send(query, parameters).as_json
      return result unless except.length.positive? || only.length.positive?

      clean_unpermitted_attributes_from_json(result, except) if except.length.positive?
      clean_unpermitted_attributes_from_json(result, result.keys - only) if only.length.positive?
    end

    ##
    # This function should run a query and return the result as a string object.
    #
    # ==== Attributes
    #
    # * +query+ - The name of the query that should be executed.
    # * +parameters+ - An object containing the parameters for the query.
    ##
    def self.as_string(query, parameters = {})
      as_json(query, parameters).to_s
    end

    ##
    # This function should run a query and return the result as a bytes array.
    #
    # ==== Attributes
    #
    # * +query+ - The name of the query that should be executed.
    # * +parameters+ - An object containing the parameters for the query.
    ##
    def self.as_bytes(query, parameters = {})
      as_string(query, parameters).bytes.to_a
    end

  end

end
