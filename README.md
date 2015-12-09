# piper-ruby

A Ruby management client to push JSON to [Piper Push Cache](http://www.piperpushcache.com/index.html).

[Piper Push Cache](http://www.piperpushcache.com/index.html). is a websocket
based push cache. A JSON cache is maintained that can be updated via a REST HTTP
API or through alternative means. This cache is pushed through websockets to
browsers using a class and object based subscription protocol that mirrors the
objects in the REST API. Piper is also a simple web server.

Piper Push Ruby is a thin client that can be used to push JSON to
[Piper](http://www.piperpushcache.com/index.html). Raw JSON can be pushed to
Piper or Ruby Objects can be pushed and [Oj](http://www.ohler.com/oj) will be
used to convert those Objects into JSON using the compat mode.

Piper Push Cache has special support for log messages. This gem provides methods
for sending those log messages to Piper.

This Piper client support publishing on [NATS](http://nats.io) as a means of
delivery if the NATS gem is installed. A flag is also provided to control which
method is used to deliver log messages to Piper.

## Release Notes

### Release 1.1.2 - December 9, 2015

 - Removed an extranious 'z' character in the where field.

### Release 1.1.1 - November 13, 2015

 - Corrected default log location to be the caller instead of the log class file.

### Release 1.1.0 - November 12, 2015

 - Added support for publishing to Piper.

 - Added support for sending log records to Piper.

### Release 1.0.0 - October 8, 2015

 - Initial release



