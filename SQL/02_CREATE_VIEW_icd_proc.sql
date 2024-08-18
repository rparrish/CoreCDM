

CREATE OR REPLACE VIEW icd_proc as (
SELECT
	--  p.subject_id
	  p.hadm_id
	, p.seq_num
	, p.icd_code
	, p.icd_version
	, d_ip.long_title 
FROM mimiciv_hosp.procedures_icd p
INNER JOIN mimiciv_hosp.d_icd_procedures d_ip
	ON (d_ip.icd_code = p.icd_code AND d_ip.icd_version = p.icd_version)
WHERE 1=1 
--AND seq_num = 1
--AND hadm_id = 21607814
--AND long_title LIKE 'Contin% ventilation%'
ORDER BY hadm_id, seq_num
) --TO 'Data/CoreCDM/ICD_PROC.parquet' (FORMAT PARQUET);

