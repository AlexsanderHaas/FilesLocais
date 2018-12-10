CREATE TABLE IF NOT EXISTS LOG_KMEANS_SCAN_PORT (  
  PROTO         VARCHAR,
  PREDICTION    INTEGER       NOT NULL,
  ID_ORIG_H     VARCHAR,
  ID_RESP_H     VARCHAR, 
  TS_FILTRO     TIMESTAMP     NOT NULL, --Filtro do TIMESTAMP utilizado na seleção dos dados para análise
  TS_CODE	      TIMESTAMP     NOT NULL, 
  ROW_ID        UNSIGNED_LONG NOT NULL, 

  TS            TIMESTAMP, 
  COUNT         UNSIGNED_LONG,  
  ID_ORIG_P     UNSIGNED_LONG,     
  DURATION      UNSIGNED_LONG,
  ORIG_PKTS     UNSIGNED_LONG,
  ORIG_IP_BYTES UNSIGNED_LONG,
  ORIG_BYTES    UNSIGNED_LONG,
  RESP_PKTS     UNSIGNED_LONG,
  RESP_IP_BYTES UNSIGNED_LONG,
  RESP_BYTES    UNSIGNED_LONG,
--  FEATURES      DOUBLE ARRAY[1], são as colunas que escolhi para calcular os centroides
  CENTROID      VARCHAR[]
	  
  CONSTRAINT PK PRIMARY KEY( PROTO     ,
                             PREDICTION,
                             ID_ORIG_H ,
                             ID_RESP_H ,
                             TS_FILTRO ,
                             TS_CODE   ,
                             ROW_ID     ));