CREATE TABLE IF NOT EXISTS LOG_TOTAIS (  
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

  DURATION    UNSIGNED_LONG,
  ORIG_PKTS   UNSIGNED_LONG,
  ORIG_BYTES  UNSIGNED_LONG,
  RESP_PKTS   UNSIGNED_LONG,
  RESP_BYTES  UNSIGNED_LONG,
	  
  CONSTRAINT pk PRIMARY KEY( TIPO     ,							               
							               TS_FILTRO,
							               TS_CODE,
                             ROW_ID ));