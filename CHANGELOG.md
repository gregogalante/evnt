# Evnt changelog

## Version 3.0

### New features:

- Added validator datetime type tests.

### Bug fixed:

/

## Version 2.1.6

- Added datetime type validation on validator class.

## Version 2.1.5

- Fixed date validator to not support string date.

## Version 2.1.4

- Fixed handler with multiple events errors. Now the **on** method of the handler should call the block immediately and the methods used on the event have different names for each event.

## Version 2.1.3

- Added date type on type validator.

## Version 2.1.2

- Updated event extras hash to have keys without the "_" first char.

## Version 2.1.1

- Initialize numeric validation on validator.
- Added error management on validator public functions.
- Added nil value accepted on validate types validator.
- Added secondary informations on gem description.

## Version 2.1.0

- Initialize code examples on repository.
- Rename the "stop" function inside commands to "err".
- Add single validation for commands parameters with the Validator class.
- Update tests.

## Version 2.0.1

- Rename "throw" function to "stop" inside commands.
- Fix payload validation inside event.

## Version 2.0

- Rename actions to commands.
- Add possibility to share extra data not saved on event payload from command to event and from event to handlers.
- Update handlers structure.

## Version 1.0.3

- Remove rails generators.

## Version 1.0.2

- Update tests structure.
- Add informations to load gem on rubygems.

## Version 1.0.1

- Add rails generators to initialize gem on rails projects.
- Add rails generators to initialize users authentication events.
- Add rails generators to initialize crud events.

## Version 1.0

- First official release.
