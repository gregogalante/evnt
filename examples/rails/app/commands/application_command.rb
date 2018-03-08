# frozen_string_literal: true

# ApplicationCommand.
class ApplicationCommand < Evnt::Command

  default_options exceptions: false,
                  nullify_empty_params: false

end
