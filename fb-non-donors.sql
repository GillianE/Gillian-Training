select e.email_address__c
     , c.Phone
     , c.firstname
     , c.lastname
     , c.mailingcity
     , c.mailingstate
     , c.mailingpostalcode
     , c.mailingcountry
     , c.birthdate
  from sf.contact c
  join sf.email e on c.Id = e.contact__c
 where e.opt_in__c = 'true'
   and e.undeliverable__c = 'false';