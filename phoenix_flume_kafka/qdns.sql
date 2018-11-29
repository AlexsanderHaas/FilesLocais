--SELECT COUNT (*)
SELECT 
--select 
--tipo,
ts_code,
ts,       
uid,
rowid
--id_orig_h,
--id_orig_p, 
--id_resp_h, 
--id_resp_p, 
--proto,     
--query,
--answers
FROM JSON00
--WHERE tipo = 'DNS';
WHERE tipo = 'DNS'
--WHERE tipo = 'CONN'
--AND TS_CODE >= TO_TIMESTAMP ('2018-11-28 15:09:00.000')
--AND proto = 'tcp'
ORDER BY rowid;
--WHERE TS_CODE >= TO_TIMESTAMP ('1542571843'); --https://phoenix.apache.org/language/functions.html#to_timestamp