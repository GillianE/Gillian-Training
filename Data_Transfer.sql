--ACLU Voter List

CREATE TEMP TABLE salesforce_emails AS

SELECT
	UPPER(TRIM(email_address__c)) AS email
	, min(createddate)::Date AS created_date 
FROM
	sf.email
WHERE 
	opt_in__c = 'true' 
AND 
	undeliverable__c = 'false'
GROUP BY 
	1
;

DROP TABLE IF EXISTS all_emails_dupes;  --all salesforce plus people power
CREATE TEMP TABLE all_emails_dupes AS

SELECT * FROM aclu_voter_reporting.people_power_list
UNION ALL
SELECT * FROM salesforce_emails
;

DROP TABLE IF EXISTS aclu_voter_reporting.all_subscribed;  --all emails de-duped 
CREATE TABLE aclu_voter_reporting.all_subscribed AS

SELECT 
	email
  , min(created_date) AS created_date
FROM all_emails_dupes
GROUP BY
	1
;

--People Power Opt Ins

DROP TABLE IF EXISTS aclu_voter_reporting.people_power_list;
CREATE TABLE aclu_voter_reporting.people_power_list AS 

SELECT 
	UPPER(TRIM(email)) AS email
	, min(created_at)::date AS created_date
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
GROUP BY 
	email
;

