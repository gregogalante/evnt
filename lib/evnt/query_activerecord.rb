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
    # * +except+ - The list of attributes that should be removed from the json.
    # * +only+ - The list of parameters that shoud be accepted for the json.
    ##
    def self.as_json(query, parameters, except: [], only: [])
      result = send(query, parameters).as_json
      return result unless except.length.positive? || only.length.positive?

      clean_unpermitted_attributes_from_json(result, except) if except.length.positive?
      clean_unpermitted_attributes_from_json(result, result.keys - only) if only.length.positive?
    end

  end

end
