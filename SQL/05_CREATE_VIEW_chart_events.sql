
CREATE OR REPLACE VIEW chart_events AS (
SELECT
	--  c.subject_id
	  c.hadm_id
	--, c.stay_id
	--, c.caregiver_id
	, c.charttime
	--, c.storetime
	, c.itemid
	, di.category 
	, di.label as item_desc
	, di.abbreviation  as item_short_name
	--, di.unitname 
	--, di.param_type 
	, c.value
	, c.valuenum
	, c.valueuom
	, c.warning
FROM mimiciv_icu.chartevents c
INNER JOIN mimiciv_icu.d_items di
ON di.itemid = c.itemid 
WHERE 1=1
AND category NOT IN ('Labs')
) --TO 'Data/CoreCDM/CHART_EVENTS.parquet' (FORMAT PARQUET);

	
