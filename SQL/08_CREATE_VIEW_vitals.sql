
CREATE OR REPLACE VIEW vitals as (
SELECT
	--  c.subject_id
	  c.hadm_id
	--, c.stay_id
	--, c.caregiver_id
	, c.charttime
	--, c.storetime
	, c.itemid
	--, di.category 
	, di.label as item_desc
	, di.abbreviation  as item_short_name
	--, di.unitname 
	--, di.param_type 
	--, c.value
	, c.valuenum
	, c.valueuom
	, c.warning
FROM mimiciv_icu.chartevents c
INNER JOIN mimiciv_icu.d_items di
ON di.itemid = c.itemid 
WHERE 1=1
--AND category  IN (
--'Routine Vital Signs',
--'Hemodynamics',
--'Respiratory',
--'Pulmonary',
--'MD Progress Note',
--'Adm History/FHPA',
--'Cardiovascular',
--'Cardiovascular (Pulses)'
--''
--) 
AND c.itemid IN (
'223761',  -- Temperature Fahrenheit  
'220045',  -- Heart Rate
'220050',  -- Arterial Blood Pressure mean
'220051',  -- Arterial Blood Pressure diastolic
'220052',  -- Arterial Blood Pressure systolic 
'220179',  -- Non Invasive Blood Pressure systolic
'220180',  -- Non Invasive Blood Pressure diastolic
'220181',  -- Non Invasive Blood Pressure mean
'220210',  -- Respiratory Rate  
'220277',  -- O2 saturation pulseoxymetry
''
)
) -- TO 'Data/CoreCDM/VITALS.parquet' (FORMAT PARQUET);

	
