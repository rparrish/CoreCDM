

CREATE OR REPLACE VIEW adt as (
SELECT
	  hadm_id 
	--, subject_id 
	, transfer_id
	, eventtype
	, careunit
	, intime as in_dts
	, outtime as out_dts
FROM mimiciv_hosp.transfers t
) --TO 'Data/CoreCDM/ADT.parquet' (FORMAT PARQUET);
