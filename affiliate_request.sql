DROP TABLE IF EXISTS email_contact; 
CREATE TEMP TABLE email_contact AS 
SELECT UPPER(TRIM(e.email_address__c)) as email 
	, a.name
	, a.billingstreet
	, a.billingcity
	, a.billingstate
	, a.billingpostalcode
FROM sf.email e
JOIN sf.contact c
ON e.contact__c = c.id
JOIN sf.account a
ON a.id = c.accountid
WHERE e.opt_in__c = 'true'
AND e.undeliverable__c = 'false'
;

--count all opted in emails graded A-D
SELECT COUNT (g.email) 
FROM email_contact e
JOIN gillian.dailyrawgrades_20180918 g
ON e.email = UPPER(TRIM(g.email))
WHERE g.rollup_grade != 'F' 
;

--count all opted in emails grades A-D with full addresses
SELECT COUNT (g.email) 
FROM email_contact e
JOIN gillian.dailyrawgrades_20180918 g
ON e.email = UPPER(TRIM(g.email))
AND g.rollup_grade != 'F' 
WHERE e.billingstreet IS NOT NULL
AND e.billingcity IS NOT NULL
AND e.billingstate IS NOT NULL
AND e.billingpostalcode IS NOT NULL 
;