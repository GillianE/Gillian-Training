select e.email_address__c as email
     , TRIM(c.Phone) as phone
     , c.firstname as fn
     , c.lastname as ln
     , c.mailingcity as ct 
     , c.mailingstate as st
     , c.mailingpostalcode as zip
     , c.mailingcountry as country
     , c.birthdate as dob
  from sf.contact c
  join sf.email e on c.Id = e.contact__c
  join sf.account a on a.Id = c.AccountId
 where e.opt_in__c = 'true'
   and e.undeliverable__c = 'false'
   and a.hpc36_amount__c >= 250.00
   and a.hpc36_amount__c <= 999.99;