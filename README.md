# piper-push-ruby
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
