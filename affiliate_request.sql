DROP TABLE IF EXISTS email_contact; 
CREATE TEMP TABLE email_contact AS 
SELECT UPPER(TRIM(e.email_address__c)) as email 
	, a.name
	, a.billingstreet
	, a.billingcity
	, a.billingstate
	, a.billingpostalcode
	, p.email_list_code__c
FROM sf.email e
JOIN sf.contact c
ON e.contact__c = c.id
JOIN sf.account a
ON a.id = c.accountid
JOIN sf.email_preference p
ON e.id = p.email__c
WHERE e.opt_in__c = 'true'
AND e.undeliverable__c = 'false'
AND p.email_list_code__c IN ('AK', 'AL', 'AR', 'AZ', 'CA', 'CD', 'CN', 'CO', 'CS', 'CT', 'DC', 'DE', 'em', 'FL', 'GA', 'HI', 'IA', 'ID', 'IL', 'IN', 'km', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA', 'WI', 'WV', 'WY')
;

--count all opted in emails grades A-D without full addresses
SELECT COUNT (g.email) 
FROM email_contact e
JOIN gillian.dailyrawgrades_20180918 g
ON e.email = UPPER(TRIM(g.email))
AND g.rollup_grade != 'F' 
WHERE (e.billingstreet IS NULL
	OR e.billingcity IS NULL
	OR e.billingstate IS NULL
	OR e.billingpostalcode IS NULL
	OR e.billingpostalcode = '00000')
;