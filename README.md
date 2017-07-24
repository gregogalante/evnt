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
    Cruds::CreateSomethingEvent.new(
      uuid: uuid,
      title: params[:title],
      user_creator_uuid: params[:user_creator_uuid]
    )
  end

end
```

## Not for production projects ready!