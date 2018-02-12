# frozen_string_literal: true

require 'rails/generators/base'

module Evnt

  # CommandGenerator.
  class CommandGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    argument :informations, type: :array, optional: false

    def create_comand
      path = informations.first.split('::')
      @command_class = path.last.camelize
      @command_modules = path - [path.last]
      @command_params = (informations - [informations.first]).map do |data|
        data = data.split(':')
        data.length > 1 ? ":#{data.first}, type: :#{data.last}" : ":#{data.first}"
      end

      template(
        './command/command.rb.erb',
        command_path
      )
    end

    def command_path
      path = './app/commands'
      @command_modules.map { |m| path = "#{path}/#{m.underscore}" }
      path = "#{path}/#{@command_class.underscore}.rb"
      path
    end

  end

end
