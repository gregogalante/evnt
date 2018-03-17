# frozen_string_literal: true

module Evnt

  ##
  # Queries are used to read and prepare data from the database
  # to the client.
  # The Query class should contain only helpers used to develop custom queries.
  ##
  class Query

    ##
    # The constructor should not be used. Use class method insthead.
    ##
    def initialize
      raise SystemCallError, 'Query can not be initialized'
    end

    def self.as_json(query, parameters, except: [], only: [])
      raise NotImplementedError, 'As json method should be implemented on Query subclasses'
    end

    # Helpers:
    ############################################################################

    def self.clean_unpermitted_attributes_from_json(obj, unpermitted_attributes)
      if obj.is_a?(Array)
        obj.map { |o| unpermitted_attributes.each { |attribute| o.delete(attribute.to_s) } }
      else
        unpermitted_attributes.each { |attribute| obj.delete(attribute.to_s) }
      end

      obj
    end

    private_class_method :clean_unpermitted_attributes_from_json

  end

end
