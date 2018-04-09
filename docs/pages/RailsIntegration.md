# Rails integration

Evnt can be used with Ruby on Rails to extends the MVC pattern.

## Generators integration

There's a simple generator that can be used to inizialize a Rails application with Evnt.

```shell

rails generate evnt:initializer --migrated

```

The **migrated** option is used to generate a model EvntEvent used to save events on a table of the database.

This command should:

- Create an **application_command.rb** on app/commands directory.
- Create an **application_event.rb** on app/events directory.
- Create an **application_handler.rb** on app/handlers directory.
- Create an **application_query.rb** on app/queries directory.
- Create tests for the three new classes added on the project.
- Added app/commands, app/events, app/handlers and app/queries on config.autoload_paths setting of the application.

### Command generators

Usage:

```shell

rails generate evnt:command Authentication::LoginCommand email:string password:string ip_address:string

```

Output:

```ruby
# ./app/commands/authentication/login_command.rb
module Authentication
  class LoginCommand < ApplicationCommand

    validates :email, type: :string

    validates :password, type: :string

    validates :ip_address, type: :string

  end
end
```

### Event generators

Usage:

```shell

rails generate evnt:event Authentication::LoginEvent user_uuid ip_address

```

Output:

```ruby
# ./app/events/authentication/login_event.rb
module Authentication
  class LoginEvent < ApplicationEvent

    name_is :authentication_login

    attributes_are :user_uuid, :ip_address

  end
end
```

### Handler generators

Usage:

```shell

rails generate evnt:handler AuthenticationHandler authentication_login authentication_signup

```

Output:

```ruby
# ./app/handlers/authentication_handler.rb
class AuthenticationHandler < ApplicationHandler

  on :authentication_login do; end

  on :authentication_signup do; end

end
```

## Manual integration

To use the gem with Rails you need to create three folders inside the ./app project's path:

- **./app/commands**
- **./app/events**
- **./app/handlers**

You also need to require all files from these folders. To do this you need to edit the ./config/application.rb file like this example:

```ruby

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyApplicationName
  class Application < Rails::Application

    config.autoload_paths << Rails.root.join('app/commands')
    config.autoload_paths << Rails.root.join('app/events')
    config.autoload_paths << Rails.root.join('app/handlers')

  end
end

```