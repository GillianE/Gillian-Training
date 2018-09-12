select e.email_address__c as email
     , c.Phone as phone
     , c.firstname as fn
     , c.lastname as ln
     , c.mailingcity as ct 
     , c.mailingstate as st
     , c.mailingpostalcode as zip
     , c.mailingcountry as country
     , c.birthdate as dob
  from sf.contact c
  join sf.email e on c.Id = e.contact__c
 where e.opt_in__c = 'true'
   and e.undeliverable__c = 'false';