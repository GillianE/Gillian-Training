

DROP TABLE IF EXISTS de_dup;
CREATE TEMP TABLE de_dup AS 

SELECT 
	UPPER(TRIM(cu.email)) AS email
	, cu.created_at::date AS created_date
	, cu.id
	, cu.first_name
    , cu.last_name
    , cu.city
    , cu.state
    , cu.postal
    , cu.country
FROM 
	ak.core_user cu
WHERE EXISTS 	
	(	
		SELECT *
		FROM 
			ak.core_subscription sub
		WHERE 
			sub.user_id = cu.id
		AND
			sub.list_id IN (SELECT id FROM ak.core_list WHERE id not IN (3, 4))
	)
AND cu.subscription_status = 'subscribed'
;

DROP TABLE IF EXISTS final;
CREATE TABLE final AS
SELECT d.email
    , d.first_name
    , d.last_name
    , d.city
    , d.state
    , d.postal
    , d.country
    , cp.normalized_phone AS phone 
FROM de_dup d 
LEFT JOIN ak.core_phone cp ON d.id = cp.user_id
;

