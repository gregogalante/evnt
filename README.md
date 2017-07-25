# Evnt

CQRS and Event Driven Development architecture for ruby projects.

- [Structure](#structure)
  - [Action](#action)
  - [Event](#event)
  - [Handler](#handler)
- [Rails integration](#rails-integration)
  - [Initialization](#initialization)

## Structure

Evnt is developed to be used over all kinds of projects and frameworks (like Ruby on Rails or Sinatra), so it contains only three types of entities:

- Action
- Event
- Handler

### Action

Actions are used to run single tasks on the system. It's like a controller on an MVC architecture without the communication with the client.

Every action has three steps to execute:

- The params validation which validates the parameters used to run the action.
- The logic validation which checks the action can be executed in compliance with the system rules.
- The event intialization which initializes an event object used to save the action.

An example of action should be:

```ruby
class CreateSomethingAction < Evnt::Action

  to_validate_params do
    # check params presence
    throw 'Title should be present' if params[:title].blank?
    throw 'User creator uuid should be present' if params[:user_creator_uuid].blank?
  end

  to_validate_logic do
    # check no others things exists with same title
    same_things = Thing.where(title: params[:title])
    throw 'Thing already exists' unless same_things.empty?
  end

  to_initialize_events do
    # generate uuid
    uuid = SecureRandom.uuid
    # initialize event
    CreateSomethingEvent.new(
      uuid: uuid,
      title: params[:title],
      user_creator_uuid: params[:user_creator_uuid]
    )
  end

end
```

An example of action usage should be:

```ruby
action = CreateSomethingAction.new(
  title: 'Foo',
  user_creator_uuid: 'bar'
)

unless action.completed?
  puts action.errors.to_sentence
else
  puts "Action completed with params #{action.params}"
end
```

- The method **completed?** returns a boolean value used to check if action is correct or not.
- The method **errors** returns an array of errors generated from the action with the function throw.
- The method **params** returns an hash with the action params.

It's also possible to use throw to raise an exception with the parameter "action_exceptions: true". An example of usage should be:

```ruby
begin
  action = CreateSomethingAction.new(
    title: 'Foo',
    user_creator_uuid: 'bar',
    action_exceptions: true
  )
rescue => e
  puts e
end
```

### Event

Events are used to save on a persistent data structure what happends on the system.

Every event has three informations:

- The name is an unique identifier of the event.
- The attributes are the list of attributes required from the event to be saved.
- The handlers are a list of handler objects which will be notified when the event is completed.

Every event has also a single function used to write the event information on the data structure.

An example of event should be:

```ruby
class CreateSomethingEvent < Evnt::Event

  name_is :create_something

  attributes_are :uuid, :title, :user_creator_id

  handlers_are [
    CreateSomethingHandler.new
  ]

  to_write_event do
    # save event
    raise 'Error on event save' unless Event.create(
      name: name,
      payload: payload
    )
  end

end
```

An example of event usage should be:

```ruby
class CreateSomethingAction < Evnt::Action

  to_initialize_events do
    # generate uuid
    uuid = SecureRandom.uuid
    # initialize event
    event = CreateSomethingEvent.new(
      uuid: uuid,
      title: params[:title],
      user_creator_uuid: params[:user_creator_uuid]
    )
    # puts event info
    puts "Event #{event.name} completed with payload #{event.payload}"
  end

end
```

- The method **name** returns the event name.
- The method **payload** returns an hash with the event payload (constructor parameters, the name and the timestamp).

After the execution of the to_write_event block the event object should notify all its handlers.

Sometimes you need to reload an old event to notify handlers for a second time. To initialize a new event object with the payload of an old event you can add the parameter "event_reloaded: true":

```ruby
events = Event.where(name: 'create_something')
reloaded_event = Event.new(events.sample.payload, event_reloaded: true)
```

### Handler

Handlers are used to listen one or more events and run tasks after their execution.

Every handler has two steps to execute:

- The queries update which updates temporary data structures used to read datas.
- The manage event code which run other tasks like mailers, parallel executions ecc.

An example of handler shuould be:

```ruby
class CreateSomethingHandler < Evnt::Handler

  to_update_queries do
    # save the thing on the Thing read model
    Thing.create(
      uuid: event_payload[:uuid],
      title: event_payload[:title],
      user_creator_uuid: event_payload[:user_creator_uuid]
    )
  end

  to_manage_event do
    # puts the event name
    puts "Listening event #{event_name} with payload #{event_payload}"
    puts "Event is reloaded? #{event.reloaded?}" # -> false
    # send an email notification to user
    UserMailer.notify_creation(
      title: event_payload[:title],
      user_uuid: event_payload[:user_creator_uuid]
    ).deliver_later
  end

end
```

- The method **event** returns the event object.
- The method **event_name** returns the event name.
- The method **event_payload** returns the event payload.

The execution of to_update_queries block runs after every events initialization.
The execution of to_manage_event block runs only for not reloaded events initialization.

Sometimes you need to run some code to manage only reloaded events. To run code only for reloaded events you can use the to_manage_reloaded_event block:

```ruby
class CreateSomethingHandler < Evnt::Handler

  to_manage_reloaded_event do
    # puts the event name
    puts "Listening event #{event_name} with payload #{event_payload}"
    puts "Event is reloaded? #{event.reloaded?}" # -> true
  end

end
```

## Rails integration

Evnt gem contains a list of generators used to speed up the rails integration.

### Initialization

To initialize Evnt on a Rails application run:

```console
rails generate evnt:initializer
```

This command should:

- Create a evnt.rb file inside the config/initializer path.
- Create a application_action.rb file inside the app/actions path.
- Create a application_event.rb file inside the app/events path.
- Create a application_handler.rb file inside the app/handlers path.