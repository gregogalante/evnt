# Evnt

CQRS and Event Driven Development architecture for ruby projects.

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
    same_things = Things.where(title: params[:title])
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

It's also possible to use throw to raise an exception thanks to the parameter "action_exceptions: true". An example of usage should be:

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
class CreateSomethingEvent < Evnt::Action

  name_is :create_something

  attributes_are :uuid, :title, :user_creator_id

  handlers_are [
    CreateSomethingHandler.new
  ]

  to_write_event do
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

After the execution of the to_write_event code the event object should notify all its handler.

Sometimes you need to reload an old event to notify handlers for a second time. To initialize a new event object with the payload of an old event you can add the parameter "event_reloaded: true":

```ruby
events = Event.where(name: 'create_something')
reloaded_event = Event.new(events.sample.payload, event_reloaded: true)
```


## Not for production projects ready!