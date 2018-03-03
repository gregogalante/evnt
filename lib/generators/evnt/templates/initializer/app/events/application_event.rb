# frozen_string_literal: true

# ApplicationEvent.
class ApplicationEvent < Evnt::Event

  default_options silent: false

  to_write_event do
    # EventModel.create(
    #   name: name,
    #   payload: payload
    # )
  end

end
