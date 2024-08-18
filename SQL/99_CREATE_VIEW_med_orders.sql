
-- Medication orders
--
-- Note: the medication order data is 
-- incomplete - only avialable for hospital (non-ICU) medications
-- _emar_ only available for 50% of subjects 
-- and _inputevents_ table only while in ICU for a subset of meds
-- https://github.com/MIT-LCP/mimic-code/discussions/1464

CREATE OR REPLACE VIEW med_orders as (
SELECT
	--  e.subject_id
	  rx.hadm_id
	, rx.poe_id
	--, e.emar_seq
	, p.pharmacy_id
	--, e.enter_provider_id
	, p.medication
	, ndc
	, gsn
--	, e.emar_id
--	, e.event_txt AS emar_event_txt
--	, e.charttime AS emar_chart_dts
	--, e.scheduletime
	--, e.storetime
	--, p.entertime AS order_enter_dts
	--, p.verifiedtime AS order_verified_dts
FROM mimiciv_hosp.prescriptions rx
LEFT JOIN mimiciv_hosp.pharmacy p 
  ON p.pharmacy_id = rx.pharmacy_id
--LEFT JOIN  mimic4demo.mimiciv_hosp.emar e
--  ON e.poe_id = rx.poe_id
WHERE 1=1
AND drug_type = 'MAIN'
) --TO 'Data/CoreCDM/MED_ORDERS.parquet' (FORMAT PARQUET);
