# frozen_string_literal: true

# Require evnt custom files:

# require actions
Dir[File.join(Rails.root, 'app', 'actions', '**/*.rb')].each do |f|
  require f
end

# require events
Dir[File.join(Rails.root, 'app', 'events', '**/*.rb')].each do |f|
  require f
end

# require handlers
Dir[File.join(Rails.root, 'app', 'handlers', '**/*.rb')].each do |f|
  require f
end
