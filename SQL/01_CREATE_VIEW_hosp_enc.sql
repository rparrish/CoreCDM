

CREATE OR REPLACE VIEW hosp_adm as (
WITH pdx AS (
SELECT
	  d.subject_id
	, d.hadm_id
	, d.seq_num
	, d.icd_code
	, d.icd_version
	, d_id.long_title 
FROM mimiciv_hosp.diagnoses_icd d
INNER JOIN mimiciv_hosp.d_icd_diagnoses d_id
	ON (d_id.icd_code = d.icd_code AND d_id.icd_version = d.icd_version)
WHERE 1=1 
AND seq_num = 1
), 
DRG AS (
SELECT
	subject_id
	, hadm_id
	, drg_type
	, drg_code
	, description
	, drg_severity
	, drg_mortality
FROM
	mimiciv_hosp.drgcodes 
WHERE 1=1
AND drg_type = 'HCFA'
),
APRDRG AS (
SELECT
	subject_id
	, hadm_id
	, drg_type
	, drg_code
	, description
	, drg_severity
	, drg_mortality
FROM
	mimiciv_hosp.drgcodes 
WHERE 1=1
AND drg_type = 'APR'
)
SELECT
	  a.hadm_id
	, a.subject_id 
	, p.anchor_age AS age 
	, p.gender 
	, a.admittime AS admit_dts
	, a.dischtime AS discharge_dts
	, a.admission_type
	--, admit_provider_id
	, a.admission_location
	, a.insurance
	--, "language"
	--, marital_status
	--, race
	, drg.drg_code
	, drg.description
	, aprdrg.drg_code AS aprdrg_code
	, aprdrg.description AS aprdrg_desc
	, aprdrg.drg_severity AS aprdrg_severity
	, aprdrg.drg_mortality aS aprdrg_mortality
	, pdx.icd_code AS prim_diag_code
	, pdx.long_title AS prim_diag_desc
	, a.edregtime AS ed_registration_dts
	, a.edouttime AS ed_depart_dts
	, a.discharge_location
	, a.hospital_expire_flag
	, a.deathtime AS death_time_dts
FROM mimiciv_hosp.admissions a
INNER JOIN	mimiciv_hosp.patients p
	ON p.subject_id = a.subject_id
INNER JOIN pdx ON Pdx.subject_id = a.subject_id
INNER JOIN drg ON drg.subject_id = a.subject_id
INNER JOIN aprdrg ON aprdrg.subject_id = a.subject_id
WHERE 1=1
) 
--TO 'Data/CoreCDM/HOSP_ADM.parquet' (FORMAT PARQUET);
