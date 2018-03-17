# frozen_string_literal: true

require 'rails/generators/base'

module Evnt

  # QueryGenerator.
  class QueryGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    argument :informations, type: :array, optional: false

    def create_comand
      path = informations.first.split('::')
      @query_class = path.last.camelize
      @query_modules = path - [path.last]
      @query_params = informations - [informations.first]

      template(
        './query/query.rb.erb',
        query_path
      )
    end

    def query_path
      path = './app/queries'
      @query_modules.map { |m| path = "#{path}/#{m.underscore}" }
      path = "#{path}/#{@query_class.underscore}.rb"
      path
    end

  end

end
