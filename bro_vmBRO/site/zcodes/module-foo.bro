module Foo;

@load base/protocols/conn
@load base/protocols/dns

export {
    # Create an ID for our new stream. By convention, this is
    # called "LOG".
    redef enum Log::ID += { LOG };

    # Define the record type that will contain the data to log.
    type Info: record {
        ts: time        &log;
        id: conn_id     &log;
        cn: Conn::Info  &log &optional;        
        dn: DNS::Info  &log &optional;
        service: string &log &optional;
        missed_bytes: count &log &default=0;
    };
}

# Optionally, we can add a new field to the connection record so that
# the data we are logging (our "Info" record) will be easily
# accessible in a variety of event handlers.
redef record connection += {
    # By convention, the name of this new field is the lowercase name
    # of the module.
    foo: Info &optional;
};

# This event is handled at a priority higher than zero so that if
# users modify this stream in another script, they can do so at the
# default priority of zero.
event bro_init() &priority=5
{
    # Create the stream. This adds a default filter automatically.
    Log::create_stream(Foo::LOG, [$columns=Info, $path="foo"]);
}

#event connection_established(c: connection)
event new_connection(c: connection)
{
    local rec: Foo::Info = [$ts=network_time(), $id=c$id, $cn=c$conn, $dn=c$dns];

    # Store a copy of the data in the connection record so other
    # event handlers can access it.
    #c$foo = rec;    

    Log::write(Foo::LOG, rec);
}