--SELECT COUNT (*)
SELECT 
--select 
--tipo,
ts_code,
ts,       
uid
--id_orig_h,
--id_orig_p, 
--id_resp_h, 
--id_resp_p, 
--proto,     
--query 
FROM JSON9
--WHERE tipo = 'DNS';
--WHERE tipo = 'DNS';
WHERE tipo = 'CONN';
--WHERE TS_CODE >= TO_TIMESTAMP ('1542571843'); --https://phoenix.apache.org/language/functions.html#to_timestamp