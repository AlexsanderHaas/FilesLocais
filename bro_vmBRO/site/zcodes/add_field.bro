@load base/protocols/conn
@load base/protocols/dns
@load base/protocols/http

#https://www.bro.org/sphinx/frameworks/logging.html#add-fields-to-a-log
#http://mailman.icsi.berkeley.edu/pipermail/bro/2013-August/005923.html

redef record Conn::Info += {
    ## Indicate if the originator of the connection is part of the
    ## "private" address space defined in RFC1918.
    ts_double: string &optional &log;
};

redef record DNS::Info += {

    ts_double: string &optional &log;
};

redef record HTTP::Info += {

    ts_double: string &optional &log;
};

event connection_state_remove(c: connection)
{  
	#TS para data e hora normal
    #local format: string = "%F, %H:%M:%s";
    #strftime(format, c$conn$ts);

    #converte para String, assim o kafka não transforma para INT
    c$conn$ts_double = fmt("%s",c$conn$ts);    
}

#http://mailman.icsi.berkeley.edu/pipermail/bro/2017-March/011723.html
event http_message_done(c: connection, is_orig: bool, stat:  http_message_stat){
	
	c$http$ts_double = fmt("%s",c$http$ts);
}

#https://www.bro.org/sphinx/scripts/base/bif/plugins/Bro_DNS.events.bif.bro.html#id-dns_end
#event dns_end(c: connection, msg: dns_msg){
#	
#	c$dns$ts_double = fmt("%s",c$dns$ts);
#
#}

#event dns_request(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count){
#	
#	if ( c?$dns ){
#    	c$dns$ts_double = fmt("%s",c$dns$ts);
#    }
#	
#}

 event dns_message(c: connection, is_orig: bool, msg: dns_msg, len: count){

 	if ( c?$dns ){
 		c$dns$ts_double = fmt("%s",c$dns$ts);
	}
 }