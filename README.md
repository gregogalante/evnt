# Evnt

CQRS and Event Driven Development architecture for Ruby projects.

- [Installation](#installation)
- [Structure](#structure)
  - [Command](#command)
  - [Event](#event)
  - [Handler](#handler)
- [Rails integration](#rails-integration)
  - [Generators integration](#generators-integration)
    - [Command generators](#command-generators)
    - [Event generators](#event-generators)
    - [Handler generators](#handler-generators)
  - [Manual integration](#manual-integration)
- [Development](#development)

Full documentation here: https://ideonetwork.github.io/evnt/

## Installation

To use the gem you need to add it on your Gemfile

Latest version
```ruby
gem 'evnt', git: 'https://github.com/ideonetwork/evnt'
```

Legacy version
```ruby
gem 'evnt'
```

## Structure

Evnt is developed to be used over all kinds of projects and frameworks (like Ruby on Rails or Sinatra), so it contains only three types of entities:

- Command
- Event
- Handler

### Command

Commands are used to run single tasks on the system. It's like a controller on an MVC architecture.

Every command has three steps to execute:

- The params normalization and validation which validates the parameters used to run the command.
- The logic validation which checks the command can be executed in compliance with the system rules.
- The event intialization which initializes an event object used to save the command.

An example of command should be:

```ruby
class CreateOrderCommand < Evnt::Command

  validates :user_id, type: :integer, presence: true
  validates :product_id, type: :integer, presence: true
  validates :quantity, type: :integer, presence: true

  to_normalize_params do
    params[:quantity] = params[:quantity].to_i
  end

  to_validate_params do
    err 'Quantity should be positive' unless params[:quantity].positive?
  end

  to_validate_logic do
    @user = User.find_by(id: params[:user_id])
    @product = Product.find_by(id: params[:product_id])

    # check user exist
    unless @user
      err 'The user does not exist'
      break
    end

    # check product exist
    unless @product
      err 'The product does not exist'
      break
    end

    # check quantity exist for the product
    err 'The requested quantity is not available' if @product.quantity < params[:quantity]

    # check user has money to buy the product
    err 'You do not have enought money' if @user.money < @product.price * params[:quantity]
  end

  to_initialize_events do
    # generate order id
    order_id = SecureRandom.uuid

    # initialize event
    begin
      CreateOrderEvent.new(
        order_id: order_id,
        user_id: @user.id,
        product_id: @product.id,
        quantity: params[:quantity],
        _user: @user,
        _product: @product
      )
    rescue
      err 'Sorry, there was an error', code: 500
    end
  end

end
```

An example of command usage should be:

```ruby
command = CreateOrderCommand.new(
  user_id: 128,
  product_id: 534,
  quantity: 10
)

if command.completed?
  puts 'Command completed'
  puts command.params # -> { user_id: 128, product_id: 534, quantity: 10 }
else
  puts command.errors # array of hashes with a { message, code } structure
  puts command.error_messages # array of error messages
  puts command.error_codes # array of error codes
end
```

It's also possible to use err method inside the command to raise an exception with the option **exception: true**. An example of usage should be:

```ruby
begin
  command = CreateOrderCommand.new(
    user_id: 128,
    product_id: 534,
    quantity: 10,
    _options: {
      excption: true
    }
  )
rescue => e
  puts e
end
```

### Event

Events are used to save on a persistent data structure what happends on the system.

Every event has three informations:

- The **name** is an unique identifier of the event.
- The **attributes** are the list of attributes required from the event to be saved.
- The **handlers** are a list of handler objects which will be notified when the event is completed.

Every event has also a single function used to write the event information on the data structure.

An example of event should be:

```ruby
class CreateOrderEvent < Evnt::Event

  name_is :create_order

  attributes_are :order_id, :user_id, :product_id, :quantity

  handlers_are [
    ProductHandler.new,
    UserNotifierHandler.new
  ]

  to_write_event do
    # save event on database
    Event.create(
      name: name,
      payload: payload
    )
  end

end
```

An example of event usage should be:

```ruby
event = CreateOrderEvent.new(
  order_id: order_id,
  user_id: @user.id,
  product_id: @product.id,
  quantity: params[:quantity]
)

puts event.name # -> :create_order
puts event.attributes # -> [:order_id, :user_id, :product_id, :quantity]
puts event.payload # -> { order_id: 1, user_id: 128, product_id: 534, quantity: 10, evnt: { timestamp: 2017010101, name: 'create_order' } }
```

The event payload should contain all event attributes and a reserved attributes "evnt" used to store the event timestamp and the event name.

It's also possible to give datas to the event without save them on the event payload, to do this you shuld only use a key with "_" as first character. An example should be:

```ruby
event = CreateOrderEvent.new(
  order_id: order_id,
  user_id: @user.id,
  product_id: @product.id,
  quantity: params[:quantity],
  _total_price: params[:quantity] * @product.price
)

puts event.payload # -> { order_id: 1, user_id: 128, product_id: 534, quantity: 10, evnt: { timestamp: 2017010101, name: 'create_order' } }
puts event.extras # -> { total_price: 50 }
```

After the execution of the **to_write_event** block the event object should notify all its handlers.

Sometimes you need to reload an old event to notify handlers to re-build queries from events. To initialize a new event object with the payload of an old event you can pass the old event payload to the event constructor:

```ruby
events = Event.where(name: 'create_order')
reloaded_event = CreateOrderEvent.new(events.sample.payload)

puts reloaded_event.reloaded? # -> true
```

### Handler

Handlers are used to listen one or more events and run tasks after their execution.

Every handler event management has two steps to execute:

- The queries update which updates temporary data structures used to read datas.
- The manage event code which run other tasks like mailers, parallel executions ecc.

An example of handler shuould be:

```ruby
class ProductHandler < Evnt::Handler

  on :create_order do

    to_update_queries do
      # update product quantity
      product = event.extras[:product]
      product.update(quantity: product.quantity - event.payload[:quantity])
    end

    to_manage_event do
      # this block is called only for not reloaded events
    end

  end

end
```

The execution of **to_update_queries** block runs after every events initialization.
The execution of **to_manage_event** block runs only for not reloaded events initialization.

Sometimes you need to run some code to manage only reloaded events. To run code only for reloaded events you can use the **to_manage_reloaded_event** block:

```ruby
class ProductHandler < Evnt::Handler

  on :create_order do

    to_manage_reloaded_event do
      # this block is called only for reloaded events
    end

  end

end
```

## Rails integration

Evnt can be used with Ruby on Rails to extends the MVC pattern.

### Generators integration

There's a simple generator that can be used to inizialize a Rails application with Evnt.

```shell

rails generate evnt:initializer

```

This command should:

- Create an **application_command.rb** on app/commands directory.
- Create an **application_event.rb** on app/events directory.
- Create an **application_handler.rb** on app/handlers directory.
- Create tests for the three new classes added on the project.
- Added app/commands, app/events and app/handlers on config.autoload_paths setting of the application.

#### Command generators

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

#### Event generators

Usage:

```shell

rails generate evnt:event Authentication::LoginEvent user_uuid ip_address

```

Output:

```ruby
# ./app/events/authentication/login_event.rb
module Authentication
  class LoginEvent < ApplicationEvent

    name_is :authentication_login_event

    attributes_are :user_uuid, :ip_address

  end
end
```

#### Handler generators

Usage:

```shell

rails generate evnt:handler AuthenticationHandler authentication_login_event authentication_signup_event

```

Output:

```ruby
# ./app/handlers/authentication_handler.rb
class AuthenticationHandler < ApplicationHandler

  on :authentication_login_event do; end

  on :authentication_signup_event do; end

end
```

### Manual integration

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

## Development

To update the documentation run:

```console

rdoc --op docs

```
