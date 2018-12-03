SELECT 
ID_ORIG_H,
ID_RESP_H,
PROTO,  
SERVICE,
DURATION 
--ORIG_PKTS, 
--ORIG_BYTES
--RESP_PKTS, 
--RESP_BYTES
FROM CONN_IP1
WHERE ID_RESP_H IS NULL
AND PROTO = 'tcp'
AND SERVICE = 'ssl';

