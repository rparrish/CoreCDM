
CREATE OR REPLACE VIEW icd_diag as (
SELECT
	--  d.subject_id
	  d.hadm_id
	, d.seq_num
	, d.icd_code
	, d.icd_version
	, d_id.long_title 
FROM mimiciv_hosp.diagnoses_icd d
INNER JOIN mimiciv_hosp.d_icd_diagnoses d_id
	ON (d_id.icd_code = d.icd_code AND d_id.icd_version = d.icd_version)
WHERE 1=1 
--AND seq_num = 1
--AND hadm_id = 21607814
--AND long_title LIKE 'Contin% ventilation%'
ORDER BY hadm_id, seq_num
) --TO 'Data/CoreCDM/ICD_DIAG.parquet' (FORMAT PARQUET);

