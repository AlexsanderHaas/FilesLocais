##! Local site policy. Customize as appropriate.
##!
##! This file will not be overwritten when upgrading or reinstalling!

# This script logs which scripts were loaded during each run.
@load misc/loaded-scripts

# Apply the default tuning scripts for common tuning settings.
@load tuning/defaults

# Estimate and log capture loss.
@load misc/capture-loss

# Enable logging of memory, packet and lag statistics.
@load misc/stats

# Load the scan detection script.
@load misc/scan

# Detect traceroute being run on the network. This could possibly cause
# performance trouble when there are a lot of traceroutes on your network.
# Enable cautiously.
#@load misc/detect-traceroute

# Generate notices when vulnerable versions of software are discovered.
# The default is to only monitor software found in the address space defined
# as "local".  Refer to the software framework's documentation for more
# information.
@load frameworks/software/vulnerable

# Detect software changing (e.g. attacker installing hacked SSHD).
@load frameworks/software/version-changes

# This adds signatures to detect cleartext forward and reverse windows shells.
@load-sigs frameworks/signatures/detect-windows-shells

# Load all of the scripts that detect software in various protocols.
@load protocols/ftp/software
@load protocols/smtp/software
@load protocols/ssh/software
@load protocols/http/software
# The detect-webapps script could possibly cause performance trouble when
# running on live traffic.  Enable it cautiously.
#@load protocols/http/detect-webapps

# This script detects DNS results pointing toward your Site::local_nets
# where the name is not part of your local DNS zone and is being hosted
# externally.  Requires that the Site::local_zones variable is defined.
@load protocols/dns/detect-external-names

# Script to detect various activity in FTP sessions.
@load protocols/ftp/detect

# Scripts that do asset tracking.
@load protocols/conn/known-hosts
@load protocols/conn/known-services
@load protocols/ssl/known-certs

# This script enables SSL/TLS certificate validation.
@load protocols/ssl/validate-certs

# This script prevents the logging of SSL CA certificates in x509.log
@load protocols/ssl/log-hostcerts-only

# Uncomment the following line to check each SSL certificate hash against the ICSI
# certificate notary service; see http://notary.icsi.berkeley.edu .
# @load protocols/ssl/notary

# If you have libGeoIP support built in, do some geographic detections and
# logging for SSH traffic.
@load protocols/ssh/geo-data
# Detect hosts doing SSH bruteforce attacks.
@load protocols/ssh/detect-bruteforcing
# Detect logins using "interesting" hostnames.
@load protocols/ssh/interesting-hostnames

# Detect SQL injection attacks.
@load protocols/http/detect-sqli

#### Network File Handling ####

# Enable MD5 and SHA1 hashing for all files.
@load frameworks/files/hash-all-files

# Detect SHA1 sums in Team Cymru's Malware Hash Registry.
@load frameworks/files/detect-MHR

# Uncomment the following line to enable detection of the heartbleed attack. Enabling
# this might impact performance a bit.
# @load policy/protocols/ssl/heartbleed

# Uncomment the following line to enable logging of connection VLANs. Enabling
# this adds two VLAN fields to the conn.log file.
# @load policy/protocols/conn/vlan-logging

# Uncomment the following line to enable logging of link-layer addresses. Enabling
# this adds the link-layer address for each connection endpoint to the conn.log file.
# @load policy/protocols/conn/mac-logging

# Uncomment the following line to enable the SMB analyzer.  The analyzer
# is currently considered a preview and therefore not loaded by default.
# @load policy/protocols/smb

# Add 30-05 Alexsander Haas

@load base/protocols/http
redef HTTP::default_capture_password = T;

@load policy/misc/known-devices
redef Known::known_devices = {"1.0 min"};

# Add 28-11
@load base/protocols/conn

redef record Conn::Info += {
    ## Indicate if the originator of the connection is part of the
    ## "private" address space defined in RFC1918.
    is_private: string &optional &log;
};

#redef LogAscii::use_json = T; #add em 14-11-18
#redef LogAscii::json_timestamps = JSON::TS_MILLIS; #add em 18-11-18

# Add 03-06 Alexsander Haas
#@load module-foo
#@load zcodes/module-full
@load zcodes/module-devices

redef ignore_checksums = T; #add 25-11

# Add 19-08 Alexsander Haas
#@load zcodes/file_extraction # Removido 15/11/18

# Add 27-04 Alexsander Haas

@load /usr/local/bro/lib/bro/plugins/APACHE_KAFKA/scripts/Apache/Kafka
#redef Kafka::logs_to_send = set(Conn::LOG);
#redef Kafka::logs_to_send = set(Full::LOG);
#redef Kafka::topic_name = "BroLogConn";
#redef Kafka::kafka_conf = table(
#    ["metadata.broker.list"] = "flume-kafka:9092"
#);

# Add 29/09 Alexsander Haas    APÓS QUALQUER ALTERAÇÃO NOS ARQUIVOS DE CONFIGURAÇÃO DEVE SER EXECUTADO O deploy

#@load /usr/local/bro/lib/bro/plugins/APACHE_KAFKA/scripts/Apache/Kafka/logs-to-kafka.bro
#@load /usr/local/bro/lib/bro/plugins/APACHE_KAFKA/scripts/Apache/Kafka
#redef Kafka::topic_name = "";
#redef Kafka::tag_json = T;

# Add 27-04 Alexsander Haas
#@load /usr/local/bro/lib/bro/plugins/APACHE_KAFKA/scripts/Apache/Kafka/logs-to-kafka.bro
@load /usr/local/bro/lib/bro/plugins/APACHE_KAFKA/scripts/Apache/Kafka
redef Kafka::topic_name = "BroLog";
redef Kafka::tag_json = T;
redef Kafka::json_timestamps: JSON::TimestampFormat = JSON::TS_MILLIS;
#JSON::TS_ISO8601; #add em 18-11-18

redef Kafka::kafka_conf = table(
    ["metadata.broker.list"] = "flume-kafka:9092"
);

#Add 28-11
event connection_state_remove(c: connection)
{
    

    local format: string = "%efg";#"%F, %H:%M:%s";
    c$conn$is_private = fmt("%s",c$conn$ts); #strftime(format, c$conn$ts);
}

event bro_init()
{
    # handles CONN
    local conn_filter: Log::Filter = [
        $name = "kafka-conn",
        $writer = Log::WRITER_KAFKAWRITER,
        $config = table(
                ["metadata.broker.list"] = "flume-kafka:9092"
        ),
        $path = "conn"
    ];

    Log::add_filter(Conn::LOG, conn_filter);

    # handles HTTP
    local http_filter: Log::Filter = [
        $name = "kafka-http",
        $writer = Log::WRITER_KAFKAWRITER,
        $config = table(
                ["metadata.broker.list"] = "flume-kafka:9092"
        ),
        $path = "http"
    ];
    
    Log::add_filter(HTTP::LOG, http_filter);

    # handles DNS       
    local dns_filter: Log::Filter = [
        $name = "kafka-dns",
        $writer = Log::WRITER_KAFKAWRITER,
        $config = table(
                ["metadata.broker.list"] = "flume-kafka:9092"
        ),
        $path = "dns"
    ];

    Log::add_filter(DNS::LOG, dns_filter);    
}