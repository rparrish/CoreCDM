
CREATE OR REPLACE VIEW labs AS (
WITH CL AS (
-- Charted Labs (from chartevents table)
SELECT
	--  c.subject_id
	  c.hadm_id
	--, c.stay_id
	--, c.caregiver_id
	, c.charttime
	--, c.storetime
	--, c.itemid
	, c.value
	--, c.valuenum
	--, c.valueuom
	, c.warning
	, d.label as lab_desc
	, di.abbreviation  as lab_abbr
	--, di.category 
	--, di.unitname 
	--, di.param_type 
FROM mimiciv_icu.chartevents c
INNER JOIN mimiciv_icu.d_items di
ON di.itemid = c.itemid 
WHERE 1=1
AND di.category = 'Labs'
)
SELECT
	  l.hadm_id
	--, l.subject_id 
	, specimen_id
	, labevent_id
	, l.charttime
	, storetime
	, l.value
	, l.valuenum
	, valueuom
	, ref_range_lower
	, ref_range_upper
	, flag
	, priority
	, comments
	, CL.lab_desc
	, CL.lab_abbr
	, CL.warning
	, label
	, fluid
	, category
FROM mimiciv_hosp.labevents l
LEFT JOIN mimiciv_hosp.d_labitems di
ON di.itemid = l.itemid 
INNER JOIN CL 
ON CL.hadm_id = l.hadm_id 
	AND CL.charttime = l.charttime 
	AND CL.value = l.value 
WHERE 1=1
); 
-- TO 'Data/CoreCDM/LABS.parquet' (FORMAT PARQUET);
