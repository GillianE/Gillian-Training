--Non-Donor Pull
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

   --Under 1000 Over 250
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
  join sf.account a on a.Id = c.AccountId
 where e.opt_in__c = 'true'
   and e.undeliverable__c = 'false'
   and a.hpc36_amount__c >= 250.00
   and a.hpc36_amount__c <= 999.99;

   --Under 250
select e.email_address__c as email
     , c.Phone as phone
     , c.firstname as fn
     , c.lastname as ln
     , c.mailingcity as ct 
     , c.mailingstate as st
     , c.mailingpostalcode as zip
     , c.mailingcountry as country
     , c.birthdate as dob
     , a.hpc36_amount__c
  from sf.contact c
  join sf.email e on c.Id = e.contact__c
  join sf.account a on a.Id = c.AccountId
 where e.opt_in__c = 'true'
   and e.undeliverable__c = 'false'
   and a.hpc36_amount__c <= 249.99
   and a.hpc36_amount__c > 0;

   --Major Donor
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
  join sf.account a on a.Id = c.AccountId
  join sf.preference p on p.rc_bios__account__c = a.Id 
where e.opt_in__c = 'true'
   and e.undeliverable__c = 'false'
   and p.rc_bios__code_value__c = 'MM'
   and p.rc_bios__active__c = 'true'
   and (p.rc_bios__end_date__c is null or p.rc_bios__end_date__c > cast(getdate() as date));

   --GOL Sustainer
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
  join sf.account a on a.Id = c.AccountId
 where e.opt_in__c = 'true'
   and e.undeliverable__c = 'false'
   and a.rc_giving__active_sustainer__c = 'true';

   --All Records
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
  


