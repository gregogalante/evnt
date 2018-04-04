# frozen_string_literal: true

# ApplicationEvent.
class ApplicationEvent < Evnt::Event

  default_options silent: false

  # Change this block with what you want to do to save event!
  to_write_event do
    EvntEvent.create(
      name: name,
      payload: payload
    ) || set_not_saved
  end

end
