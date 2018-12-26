SELECT  
-- TIPO,		
-- TS        ,
-- ID_ORIG_H ,
-- ID_ORIG_P ,
-- ID_RESP_H ,
-- ID_RESP_P ,
-- PROTO     ,
-- UID       ,
-- ROW_ID   	,
 --"SSH".*
 --"CONN".*
PROTO,COUNT(*)
FROM JSON00
WHERE TIPO = 'CONN'
GROUP BY PROTO;
--AND PROTO = NULL;
