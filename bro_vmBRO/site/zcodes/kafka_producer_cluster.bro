@load /usr/local/bro/lib/bro/plugins/APACHE_KAFKA/scripts/Apache/Kafka

redef Kafka::topic_name = "BroLog";
redef Kafka::tag_json = T;
redef Kafka::json_timestamps: JSON::TimestampFormat = JSON::TS_MILLIS; #add em 18-11-18

redef Kafka::kafka_conf = table(
    ["metadata.broker.list"] = "namenode.ambari.hadoop:6667"
);

event bro_init()
{
    # handles CONN
    local conn_filter: Log::Filter = [
        $name = "kafka-conn",
        $writer = Log::WRITER_KAFKAWRITER,
        $config = table(
                ["metadata.broker.list"] = "namenode.ambari.hadoop:6667"
        ),
        $path = "conn"
    ];

    Log::add_filter(Conn::LOG, conn_filter);

    # handles HTTP
    local http_filter: Log::Filter = [
        $name = "kafka-http",
        $writer = Log::WRITER_KAFKAWRITER,
        $config = table(
                ["metadata.broker.list"] = "namenode.ambari.hadoop:6667"
        ),
        $path = "http"
    ];
    
    Log::add_filter(HTTP::LOG, http_filter);

    # handles DNS       
    local dns_filter: Log::Filter = [
        $name = "kafka-dns",
        $writer = Log::WRITER_KAFKAWRITER,
        $config = table(
                ["metadata.broker.list"] = "namenode.ambari.hadoop:6667"
        ),
        $path = "dns"
    ];

    Log::add_filter(DNS::LOG, dns_filter);    
}