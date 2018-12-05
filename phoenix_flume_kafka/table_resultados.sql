CREATE TABLE IF NOT EXISTS LOG_ANALYZES2 (  
  TIPO        VARCHAR,            --Tipo de análise realizada
  TS_FILTRO   TIMESTAMP NOT NULL, --Filtro do TIMESTAMP utilizado na seleção dos dados para análise
  TS_CODE	    TIMESTAMP NOT NULL, 
  ROW_ID      UNSIGNED_LONG NOT NULL, 

  COUNT       UNSIGNED_LONG, 
  PROTO       VARCHAR,
  SERVICE     VARCHAR,
  ID_ORIG_H   VARCHAR,
  ID_ORIG_P   UNSIGNED_LONG, 
  ID_RESP_H   VARCHAR,     
  ID_RESP_P   UNSIGNED_LONG, 

  "SUM(DURATION)"    UNSIGNED_LONG,
  "SUM(ORIG_PKTS)"   UNSIGNED_LONG,
  "SUM(ORIG_BYTES)"  UNSIGNED_LONG,
  "SUM(RESP_PKTS)"   UNSIGNED_LONG,
  "SUM(RESP_BYTES)"  UNSIGNED_LONG,
	  
  CONSTRAINT pk PRIMARY KEY( TIPO     ,							               
							               TS_FILTRO,
							               TS_CODE,
                             ROW_ID ));