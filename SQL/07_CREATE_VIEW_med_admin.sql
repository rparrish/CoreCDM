
-- Medication Administration times
--
-- Note: the administration data is 
-- incomplete. _emar_ only available for 50% of subjects 
-- and _inputevents_ table only while in ICU for a subset of meds
-- https://github.com/MIT-LCP/mimic-code/discussions/1464


CREATE OR REPLACE VIEW med_admin AS (
WITH meds_emar as (
    WITH route as (
        SELECT 
            ed.emar_id 
            , ed.route
        FROM mimiciv_hosp.emar_detail ed
        WHERE 1=1
        AND ed.route IS NOT NULL
        )
    SELECT
          e.hadm_id
        --, e.subject_id
        --, NULL as order_id
        --, e.emar_id
        --, e.pharmacy_id
        , 'hosp' as mar_source
        , charttime as start_dts
        , COALESCE (e.medication, p.medication) AS medication
        , dose_given
        , dose_given_unit
        , COALESCE (route.route, p.route) as route
    FROM mimiciv_hosp.emar e
    INNER JOIN mimiciv_hosp.emar_detail ed
        ON ed.emar_id = e.emar_id
    LEFT JOIN mimiciv_hosp.pharmacy p 
        ON p.pharmacy_id = e.pharmacy_id 
    LEFT JOIN route 
        ON route.emar_id = e.emar_id
    WHERE 1=1
    AND dose_given IS NOT NULL
    AND event_txt IN ('Administered', 'Restarted') 
    AND e.hadm_id IS NOT NULL 
    AND e.medication IS NOT NULL
    ), 
meds_input AS (
    SELECT
        hadm_id
        --, subject_id
        --, ie.orderid as order_id
        --, NULL AS emar_id
        --, NULL AS pharmacy_id
        , 'icu' as mar_source
        , starttime AS start_dts
        , label AS medication
        , amount as dose_given
        , amountuom as dose_given_unit
        , CASE 
            WHEN ordercategoryname IN (
                '01-Drips',
                '02-Fluids (Crystalloids)', 
                '05-Med Bolus',
                '08-Antibiotics (IV)', 
                '10-Prophylaxis (IV)',
                '12-Parenteral Nutrition'
            ) THEN 'IV'
            WHEN ordercategoryname LIKE (
                '%(Non IV)%' 
            ) THEN 'Non IV'
            ELSE NULL
            END as route
    FROM mimiciv_icu.inputevents ie
    INNER JOIN mimiciv_icu.d_items d_i
    ON d_i.itemid = ie.itemid
    AND d_i.linksto = 'inputevents'
    AND d_i.category IN ('Medications', 'Antibiotics')
    ),
mar as (
    SELECT * from meds_emar
    UNION SELECT * from meds_input
),    
rx as (
SELECT
	  rx.hadm_id
	, rx.poe_id
	, p.pharmacy_id
	, p.medication
	, ndc
	, gsn
FROM mimiciv_hosp.prescriptions rx
LEFT JOIN mimiciv_hosp.pharmacy p 
  ON p.pharmacy_id = rx.pharmacy_id
WHERE 1=1
AND drug_type = 'MAIN'
)

SELECT 
    mar.*
FROM mar
WHERE 1=1 

) --TO 'Data/CoreCDM/MED_ADMIN.parquet' (FORMAT PARQUET);