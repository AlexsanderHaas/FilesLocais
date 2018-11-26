package main;

import java.util.HashMap;
import java.util.Map;

import org.apache.spark.SparkConf;
import org.apache.spark.SparkContext;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import static org.apache.spark.sql.functions.col;
import org.apache.phoenix.spark.*;
//import org.apache.hadoop.hbase.protobuf.ProtobufUtil;D
//Add 21/08
//import org.apache.log4j.Logger;
//import org.apache.log4j.Level;

import org.apache.spark.launcher.SparkLauncher;

public class main_start {
	
	private static main_start go_st;
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		go_st = new main_start();
		
		go_st.m_select();
		
	}
	
	public void m_select() {
		
		//HBASE version 2.0.0
		//setar 5.0.0-HBase-2.0
		
		//String lv_table = "US_POPULATION";
		String lv_table = "BRO_LOG";
		
		String lv_zkurl = "namenode.ambari.hadoop:2181:/hbase-unsecure";
		
		Map<String, String> map = new HashMap<String, String>();
		
		//map.put("zkUrl", "namenode.ambari.hadoop:2181");
		map.put("zkUrl", lv_zkurl); //funcionou
		//map.put("zookeeper.znode.parent", "/hbase-unsecure");
		/*map.put("zkUrl", "namenode.ambari.hadoop,"
				+ "datanode1.ambari.hadoop,"
				+ "datanode2.ambari.hadoop/hbase-unsecure");
		map.put("zookeeper.znode.parent", "/hbase-unsecure");
		map.put("hbase.zookeeper.property.clientPort", "2181");
		map.put("hbase.zookeeper.quorum", "master");*/
		map.put("table", lv_table);
		
		SparkConf lv_conf = new SparkConf().setMaster("local[2]").setAppName("SelectLog");		
		
		//SparkConf lv_conf = new SparkConf().setAppName("SelectLog");
					
		SparkContext lv_context = new SparkContext(lv_conf);
		
		SparkSession lv_session = new SparkSession(lv_context);
		
		//Disable INFO messages-> https://stackoverflow.com/questions/48607642/disable-info-messages-in-spark-for-an-specific-application
		//Logger.getRootLogger().setLevel(Level.ERROR);
						
		//Dataset<Row> lv_df = lv_session.sqlContext().load("org.apache.phoenix.spark", map);
		
		Dataset<Row> lv_df = lv_session.sqlContext()
					.read()
					.format("org.apache.phoenix.spark")
					.options(map)
					.load();
		
		lv_df.registerTempTable(lv_table);
		 
				 
		/*Dataset<Row> lv_result = lv_df.sparkSession().sql(" SELECT * FROM BRO_LOG"
				+ " WHERE pk = '192.168.1.105-ClAP1m4Ohcjo9rLS95' ");
		
		lv_result.show();*/
		
		//lv_df.groupBy("query").count().show();
		//lv_df.printSchema();
		
		
		/*lv_df
		.filter(col("query").equalTo("imac-de-joao.local"))		
		.groupBy("id_orig_h","query")
		.count()
		.show(500);*/
		
		//Logger.getRootLogger().setLevel(Level.ERROR);
		
		//Todos dns
		/*lv_df
		.filter(col("log").equalTo("dns"))	
		.groupBy("id_orig_h", "id_orig_p", "id_resp_h", "id_resp_p", "query")
		.count()
		.show(500);*/
		
		/*//conexões
		lv_df				
		.groupBy("log")
		.count()
		.show(500);*/
		
		lv_df			
		///.groupBy("id_orig_h", "id_orig_p", "id_resp_h", "id_resp_p")
		.groupBy("id_orig_h", "id_resp_h")
		.count()
		.orderBy("count")
		.coalesce(1) //cria apenas um arquivo
		.write()
		.option("header", "true")
		.mode("overwrite") //substitui o arquivo de resultado pelo novo
		
		//.csv("/home/user/Documentos/log");
		.csv("/home/user/Documentos/log2"); //funciona 11-11-18
		//.csv("/home/hdfs/log");
		//.save("/home/hdfs/log/log.csv");
		
		/*Dataset<Row> lv_result = lv_df //comment 10-11-18 executa no cluster
								 .select(col("PK"),col("id_orig_h"),col("id_resp_h"))
								 .filter(col("log").equalTo("conn")) ;*/
								 //.groupBy("id_orig_h", "id_resp_h")
								 //.count()
								// .orderBy("count");

								//.show(500);
		/*Dataset<Row> lv_result = lv_df //comment 11-11-18 testes local
				 //.select(col("PK"),col("id_orig_h"),col("id_resp_h"))
				 .filter(col("log").equalTo("conn"))
				 .filter(col("proto").equalTo("tcp"));
				 //.filter(col("id_orig_h").equalTo("10.1.4.60"));
				 //.filter(col("ts").gt("1541881190806"));
		lv_result.show(500);
		
		Dataset<Row> lv_dns = lv_df
				 //.select(col("PK"),col("id_orig_h"),col("id_resp_h"))
				 .filter(col("log").equalTo("dns"))
				 .filter(col("id_orig_h").equalTo("10.1.4.60"));
				 //.filter(col("uid").equalTo("C84Akx1lMO1hhXdqob"));
				 //.filter(col("query").equalTo("imac de joao._sftp-ssh._tcp.local"));imac de joao._sftp-ssh._tcp.local
				 //.filter(col("ts").gt("1541881190806"));
		//lv_dns.show(500);
*/		
		//lv_result.printSchema();
		
		//Logger.getRootLogger().setLevel(Level.ERROR);
		
		
		//comment 10-11-18 executa no cluster
		/*lv_result.write()
		.format("org.apache.phoenix.spark")
		.mode("overwrite") 
		.option("table", "RESULT") 
		.option("zkUrl", lv_zkurl) 
		.save();*/

		
		//lv_df.select(col("id_orig_h"),col("id_orig_p"),col("query")).groupBy("query").count().show(500);
		//lv_df.show(500);
		
	}
	
}

















