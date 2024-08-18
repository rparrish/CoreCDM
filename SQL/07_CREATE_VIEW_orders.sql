
CREATE OR REPLACE VIEW orders AS (
SELECT
    p.hadm_id 
	, p.poe_id
	, p.poe_seq
	--, p.subject_id
	, p.ordertime
	, p.order_type
	, p.order_subtype
	, p.transaction_type
	, pd.field_name
	, pd.field_value
	, p.discontinue_of_poe_id
	, p.discontinued_by_poe_id
	, p.order_provider_id
	, p.order_status
FROM mimiciv_hosp.poe p 
INNER JOIN mimiciv_hosp.poe_detail pd 
ON pd.poe_id = p.poe_id
) -- TO 'Data/CoreCDM/ORDERS.parquet' (FORMAT PARQUET);