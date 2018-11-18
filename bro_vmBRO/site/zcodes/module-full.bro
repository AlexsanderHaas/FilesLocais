module Full;

@load base/protocols/conn
@load base/protocols/dns
@load base/protocols/http
@load /usr/local/bro/lib/bro/plugins/APACHE_KAFKA/scripts/Apache/Kafka/logs-to-kafka.bro

export {
    # Create an ID for our new stream. By convention, this is
    # called "LOG".
    redef enum Log::ID += { LOG };

    # Define the record type that will contain the data to log.
    type Info: record {
        log:                string           &log;
        ts:                 time             &log;
        uid:                string           &log;
        id:                 conn_id          &log  &optional;
             
        query:              string           &log  &optional; #DNS   
        proto:              transport_proto  &log  &optional; #DNS, CONN
        trans_id:           count            &log  &optional; #DNS  
#CONN                     
        service:            string           &log  &optional; 
        duration:           interval         &log  &optional; 
        orig_bytes:         count            &log  &optional;
        resp_bytes:         count            &log  &optional;
        conn_state:         string           &log  &optional;
        orig_pkts:          count            &log  &optional;
        orig_ip_bytes:      count            &log  &optional;
        resp_pkts:          count            &log  &optional;
        resp_ip_bytes:      count            &log  &optional;
#HTTP
        request_body_len:   count            &log  &optional; 
        response_body_len:  count            &log  &optional; 
        status_code:        count            &log  &optional; 
        status_msg:         string           &log  &optional;   
        resp_fuids:         vector of string &log  &optional; #HTTP   UID of file in FILE.log
            
    };
}

# Optionally, we can add a new field to the connection record so that
# the data we are logging (our "Info" record) will be easily
# accessible in a variety of event handlers.
redef record connection += {
    # By convention, the name of this new field is the lowercase name
    # of the module.
    full: Info &optional;
};

# This event is handled at a priority higher than zero so that if
# users modify this stream in another script, they can do so at the
# default priority of zero.
event bro_init() &priority=5
{
    # Create the stream. This adds a default filter automatically.
    
    Log::create_stream(Full::LOG, [$columns=Info, $path="full"]);    

    # handles HTTP
    local filter: Log::Filter = [
        $name = "LOG",
        $writer = Log::WRITER_KAFKAWRITER,
        $config = table(
                ["metadata.broker.list"] = "flume-kafka:9092"
        ),
        $path = "full"
    ];
    
    #Log::add_filter(Full::LOG, filter); #Se quiser transportar direto ao KAFKA

    #Log::remove_filter(Full::LOG, "default");

}

event DNS::log_dns(dns: DNS::Info)
{
    local rec: Full::Info = [$ts=network_time(), $log="DNS", $uid=dns$uid, $id=dns$id, $proto=dns$proto];#, $query=dns$query];

    if ( dns?$query ){
        rec$query = dns$query;
    }

    if ( dns?$trans_id ){
        rec$trans_id = dns$trans_id;
    }    
    

    # Store a copy of the data in the connection record so other
    # event handlers can access it.
    
    Log::write(Full::LOG, rec);    
}

event Conn::log_conn(conn: Conn::Info)
{
    local rec: Full::Info = [$ts    = network_time(), 
                             $log   = "CONN"        , 
                             $uid   = conn$uid      , 
                             $id    = conn$id       , 
                             $proto = conn$proto                             
                             ];

    if ( conn?$service ){
        rec$service = conn$service;
    }

    if ( conn?$duration ){
        rec$duration = conn$duration;
    }
    
    if ( conn?$orig_bytes ){
        rec$orig_bytes = conn$orig_bytes;
    }

    if ( conn?$resp_bytes ){
        rec$resp_bytes = conn$resp_bytes;
    }

    if ( conn?$conn_state ){
        rec$conn_state = conn$conn_state;
    }

    if ( conn?$orig_pkts ){
        rec$orig_pkts = conn$orig_pkts;
    }

    if ( conn?$orig_ip_bytes ){
        rec$orig_ip_bytes = conn$orig_ip_bytes;
    }

    if ( conn?$resp_pkts ){
        rec$resp_pkts = conn$resp_pkts;
    }

    if ( conn?$resp_ip_bytes ){
        rec$resp_ip_bytes = conn$resp_ip_bytes;
    }

    # Store a copy of the data in the connection record so other
    # event handlers can access it.
    
    #Log::write(Full::LOG, rec);
}

event HTTP::log_http(http: HTTP::Info)
{   
    local prox: set[string];
   
    local rec: Full::Info = [$ts                 = network_time()           , 
                             $log                = "HTTP"                   , 
                             $uid                = http$uid                 , 
                             $id                 = http$id                  ,
                             $request_body_len   = http$request_body_len    ,   
                             $response_body_len  = http$response_body_len   ,
                             $status_code        = http$status_code         ,
                             $status_msg         = http$status_msg
                             ];
    
    if( http?$resp_fuids ){
        
        rec$resp_fuids = http$resp_fuids;
    }

    # Store a copy of the data in the connection record so other
    # event handlers can access it.    

    #Log::write(Full::LOG, rec);
}