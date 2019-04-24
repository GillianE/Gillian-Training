DROP VIEW IF EXISTS sf.v_online_donations;
CREATE VIEW sf.v_online_donations AS
SELECT
   	   child.id AS child_giving_id,
    	   parent.id AS parent_giving_id,
	   child.close_date AS close_date,
	   parent.account_id AS account_id,
           parent.r_c_giving_primary_contact_c AS primary_contact_id,
           a.account_type_c AS account_type,
           child.deposit_site_c AS deposit_site,
           child.adjustment_code_c AS adjustment_code,
           child.amount AS amount,
           parent.account_affiliation_c AS account_affiliation,
           child.program_type_c AS program_type,
           child.fiscal_year AS fiscal_year,
           child.import_id_c AS import_id,
           parent.SB_Originating_Form_Name_c AS sb_originating_form_name,
           parent.Form_URL_c AS form_url,
           parent.SB_Form_Affiliation_c AS sb_form_affiliation,
           parent.SB_Gateway_Transaction_ID_c AS sb_form_transaction_id,
           parent.SB_Donation_Id_c AS sb_donation_id,
           child.sustainer_first_payment_c AS is_first_sustainer_payment,
           child.campaign_type_c AS campaign_type,
           child.campaign_id_text_c AS child_campaign_id,
	   parent.campaign_id AS parent_campaign_id,
	   c.campaign_name,
           parent.r_c_giving_is_sustainer_c AS is_sustainer_pledge,
           parent.sb_originating_social_share_c AS sb_originating_social_share,
           parent.sb_p_2_p_personal_campaign_c AS sb_p2p_personal_campaign,
           parent.social_referrer_transaction_c AS social_referrer_transaction,
           parent.initial_referral_url_c AS initial_referral_url,
           parent.initial_market_source_affiliation_c AS initial_market_source_affiliation,
           parent.initial_market_source_channel_c AS initial_market_source_channel,
           parent.initial_market_source_date_c AS initial_market_source_date,
           parent.initial_market_source_external_c AS initial_market_source_external,
           parent.initial_market_source_other_c AS initial_market_source_other,
           parent.market_source_affiliation_c AS market_source_affiliation,
           parent.market_source_channel_c AS market_source_channel,
           parent.market_source_external_c AS market_source_external,
           parent.market_source_other_c AS market_source_other,
	  CASE
	    WHEN child.r_c_giving_payment_method_c = 'Third Party Charge' THEN child.payment_subtype_c
            ELSE NULL END AS third_party_aggregator,
           CASE
              WHEN c.campaign_channel LIKE 'A - Advertising%' THEN 'A - Advertising'
              ELSE c.campaign_channel END AS campaign_channel,
           CASE
              WHEN c.campaign_channel = 'A - Advertising: Online Display' THEN 'Paid Display'
              WHEN c.campaign_channel = 'A - Advertising: Search Engine' THEN 'Paid Search'
              WHEN c.campaign_channel = 'A - Advertising: Social Media' THEN 'Paid Social Media'
              ELSE c.campaign_sub_channel END AS campaign_sub_channel,

           CASE
              WHEN child.record_type_id = '01236000000fBmOAAU' THEN 'Transaction'
              WHEN child.record_type_id = '01236000000fBnUAAU' THEN 'Pledge Payment'
              WHEN child.record_type_id = '01236000000OgkDAAS' THEN 'Soft Credit'
              END AS child_record_type,
           CASE
              WHEN parent.record_type_id = '01236000000fBmPAAU' THEN 'Donation'
              WHEN parent.record_type_id = '01236000000fBmuAAE' THEN 'Proposal'
              WHEN parent.record_type_id = '01236000000fBnVAAU' THEN 'Pledge'
              WHEN parent.record_type_id = '01236000000fBmsAAE' THEN 'Grant'
              END AS parent_record_type,
           CASE
              WHEN child.deposit_site_c LIKE 'NA%' THEN 'National'
              ELSE 'Affiliate' END AS banked,
           CASE
              WHEN child.program_type_c IN ('4','5') THEN 'Foundation'
              ELSE 'Union' END AS fundraising_type_c3_c4,
           CASE
              WHEN parent.initial_market_source_channel_c IN ('bf', 'fb')
                    OR parent.initial_market_source_channel_c LIKE 'i%'
                    OR parent.initial_market_source_channel_c = 'ptp'
                    OR parent.initial_market_source_channel_c LIKE 't%' THEN 'Social'
              WHEN parent.initial_market_source_channel_c LIKE 'eml%' THEN 'Email'
              WHEN parent.initial_market_source_channel_c LIKE 'web%' THEN 'Website'
              WHEN parent.initial_market_source_channel_c IN ('display', 'gad', 'fad', 'sem') THEN 'Ads'
              WHEN parent.initial_market_source_channel_c = 'sms' THEN 'SMS'
              WHEN parent.initial_market_source_channel_c = 'pod' THEN 'Podcast'
              ELSE 'Other/Unknown' END AS "Master_MS_channel",
           CASE
              WHEN child.sharing_code_c IN ('A001', 'A002', 'A003', 'C005', 'C008', 'C009') THEN 'first_time_donation'
              ELSE 'donation_from_existing_donor' END AS new_or_existing,
           CASE
              WHEN child.sharing_code_c IN ('A001', 'A002', 'A003', 'C005', 'C008', 'C009') AND parent.r_c_giving_is_sustainer_c = 'no' THEN '1X from New Donor'
              WHEN child.sharing_code_c IN ('A001', 'A002', 'A003', 'C005', 'C008', 'C009') and parent.r_c_giving_is_sustainer_c = 'yes' THEN 'GOL from New Donor'
              WHEN child.sharing_code_c = 'B003' and parent.r_c_giving_is_sustainer_c = 'no' THEN '1X from Reinstated Donor'
              WHEN child.sharing_code_c = 'B003' and parent.r_c_giving_is_sustainer_c = 'yes' THEN 'GOL from Reinstated Donor'
              WHEN child.sharing_code_c IN ('P001', 'P002', 'P003') AND parent.r_c_giving_is_sustainer_c = 'no' THEN 'First Renewal 1X Gift'
              WHEN child.sharing_code_c IN ('P001', 'P002', 'P003') AND parent.r_c_giving_is_sustainer_c = 'yes' THEN 'First Renewal Sustaining Gift'
              WHEN child.sharing_code_c IN ('D009', 'D010', 'D011', 'D012', 'E017') AND parent.r_c_giving_is_sustainer_c = 'no' THEN 'Renewal(Not First) 1X Gift'
              WHEN child.sharing_code_c IN ('D009', 'D010', 'D011', 'D012', 'E017') AND parent.r_c_giving_is_sustainer_c = 'yes' THEN 'Renewal(Not First) Sustaining Gift'
              WHEN child.sharing_code_c IN ('E013', 'E015', 'E016', 'C171') AND parent.r_c_giving_is_sustainer_c = 'no' THEN '1X Extra Contribution'
              WHEN child.sharing_code_c IN ('E013', 'E015', 'E016', 'C171') AND parent.r_c_giving_is_sustainer_c = 'yes' THEN 'Sustaining Gift Extra Contribution'
              WHEN child.sharing_code_c NOT IN ('A001', 'A002', 'A003', 'C005', 'C008', 'C009', 'B003', 'P001', 'P002', 'P003', 'D009', 'D010', 'D011', 'D012', 'E017', 'E013', 'E015', 'E016', 'C171') AND parent.r_c_giving_is_sustainer_c = 'no' THEN 'Other 1x Gift'
              WHEN child.sharing_code_c NOT IN ('A001', 'A002', 'A003', 'C005', 'C008', 'C009', 'B003', 'P001', 'P002', 'P003', 'D009', 'D010', 'D011', 'D012', 'E017', 'E013', 'E015', 'E016', 'C171') AND parent.r_c_giving_is_sustainer_c = 'yes' THEN 'Other Sustaining Gift'
              ELSE 'Other' END AS donation_type,
	  CASE
              WHEN parent.campaign_id IN ('7014A000001jnhoQAA', '7014A000001jne0QAA', '7014A000001Zj8wQAC') THEN 'Action'
              WHEN c.campaign_name LIKE 'SB: NAT:%' THEN 'Action'
              ELSE 'Member' END AS email_list_type,
          CASE
  --            WHEN (child.r_c_giving_hard_credit_account_c IN ('0013600001dW5LeAAK', -- ActBlue Civics C4
  --                    '0013600001dWDfPAAW', -- ActBlue Charities C3
  --                    '0013600001eI4sXAAS', -- Bright Funds C4
  --                    '0013600001e5gnMAAQ', -- Democracy Engine C4
  --                    '0013600001e7duDAAQ', -- Facebook C4
  --                    '0013600001eCoquAAC', -- Network For Good C4
  --                    '0013600001eLAlwAAG'  -- PayPal Giving Fund C4
  --                    '0013600001e8WjoAAE',    -- IfOnly
  --                    '0013600001e9ERkAAM',    -- JustGive
  --                    '0013600001eGPNvAAO',    -- Razoo Foundation
  --                    '0013600001eHMWHAA4',    -- Razoo Foundation
  --                    '0013600001e5QEaAAM',    -- CrowdRise
  --                    '0013600001eHGJlAAO',    -- Charity Buzz
  --                    '0013600001e4NIyAAM',    -- Razoo Foundation
  --                    '0013600001e5VFxAAM',    -- JustGiving
  --                    '0013600001eFWgNAAW',    -- Just Give
  --                    '0013600001e4h77AAA')    -- Justgive
  --                AND child.soft_credit_type_c = 'Third Party'
  --                AND child.record_type_id  = '01236000000OgkDAAS'
  --                AND child.close_date BETWEEN '01-16-2017' AND '02-23-2018') THEN 'third_party_pre'
              WHEN (child.payment_subtype_c IN ('ActBlue',
                                      'Bright Funds',
                                      'Democracy Engine',
                                      'Facebook',
                                      'First Giving',
                                      'Network For Good',
                                      'PayPal Giving Fund')
                  AND credit.soft_credit_type_c = 'Third Party'
                  AND child.r_c_giving_payment_method_c = 'Third Party Charge'
                  AND child.close_date >= '02-23-2018'
                  AND child.record_type_id  = '01236000000fBmOAAU') THEN 'third_party'
  --            WHEN (child.import_id_c IS NOT NULL
  --                AND child.close_date >= '01-01-2013'
  --                AND child.external_id_c IS NOT NULL) THEN 'online_pre'
              WHEN (child.external_id_c IS NULL
                  AND (c.campaign_channel LIKE '%Email%'
                      OR
                      c.campaign_channel LIKE '%Advertising%'
                      OR
                      c.campaign_channel LIKE '%Website%'
                      OR
                      c.campaign_channel LIKE '%Text%'
                      OR
                      c.campaign_channel LIKE '%Online%'
                      OR
                      c.campaign_channel LIKE '%Social Media%')
                  AND child.close_date >= '02-16-2018') THEN 'online'
                  ELSE NULL END AS "tpa_or_online"
 FROM sf.opportunity AS parent
     INNER JOIN sf.opportunity child
        ON child.r_c_giving_parent_c = parent.id
	AND child.is_deleted = FALSE
        AND parent.is_deleted = FALSE
     INNER JOIN sf.account AS a
        ON a.id = parent.account_id
       AND a.is_deleted = False
     INNER JOIN sf.v_campaign c
        ON parent.campaign_id = c.campaign_id
     LEFT JOIN sf.r_c_giving_opportunity_credit_c credit
        ON credit.r_c_giving_opportunity_c = parent.id AND credit.soft_credit_type_c = 'Third Party'
	AND credit.is_deleted = FALSE
     WHERE child.record_type_id IN ('01236000000fBmOAAU', -- Transaction (child)
                                  '01236000000fBnUAAU', -- Pledge Payment (child)
                                  '01236000000OgkDAAS')  -- Soft Credit (child)
     AND child.deposit_site_c NOT LIKE 'COS%'
     AND a.account_type_c <> 'Estate'
     AND child.exclude_from_revenue_sharing_c = 'f'
     AND child.stage_name = 'Completed'
     AND (child.adjustment_code_c IN ('D','N') OR child.adjustment_code_c IS NULL)
    AND
--         ((child.r_c_giving_hard_credit_account_c IN ('0013600001dW5LeAAK', -- ActBlue Civics C4
--                      '0013600001dWDfPAAW', -- ActBlue Charities C3
--                      '0013600001eI4sXAAS', -- Bright Funds C4
--                      '0013600001e5gnMAAQ', -- Democracy Engine C4
--                      '0013600001e7duDAAQ', -- Facebook C4
--                      '0013600001eCoquAAC', -- Network For Good C4
--                      '0013600001eLAlwAAG'  -- PayPal Giving Fund C4
--                      '0013600001e8WjoAAE',    -- IfOnly
--                      '0013600001e9ERkAAM',    -- JustGive
--                      '0013600001eGPNvAAO',    -- Razoo Foundation
--                      '0013600001eHMWHAA4',    -- Razoo Foundation
--                      '0013600001e5QEaAAM',    -- CrowdRise
--                      '0013600001eHGJlAAO',    -- Charity Buzz
--                      '0013600001e4NIyAAM',    -- Razoo Foundation
--                      '0013600001e5VFxAAM',    -- JustGiving
--                      '0013600001eFWgNAAW',    -- Just Give
--                      '0013600001e4h77AAA'    -- Justgive
--                      )
--                  AND child.soft_credit_type_c = 'Third Party'
--                  AND child.record_type_id  = '01236000000OgkDAAS'
--                  AND child.close_date BETWEEN '01-16-2017' AND '02-23-2018')
--      OR
        ((child.payment_subtype_c IN ('ActBlue',
                                      'Bright Funds',
                                      'Democracy Engine',
                                      'Facebook',
                                      'First Giving',
                                      'Network For Good',
                                      'PayPal Giving Fund')
                  AND credit.soft_credit_type_c = 'Third Party'
                  AND child.r_c_giving_payment_method_c = 'Third Party Charge'
                  AND child.close_date >= '02-23-2018'
                  AND child.record_type_id  = '01236000000fBmOAAU')
--      OR
--         (child.import_id_c IS NOT NULL
--                  AND child.close_date >= '01-01-2013'
--                  AND child.external_id_c IS NOT NULL)
      OR
        (child.external_id_c IS NULL
                  AND (c.campaign_channel LIKE '%Email%'
                      OR
                      c.campaign_channel LIKE '%Advertising%'
                      OR
                      c.campaign_channel LIKE '%Website%'
                      OR
                      c.campaign_channel LIKE '%Text%'
                      OR
                      c.campaign_channel LIKE '%Online%'
                      OR
                      c.campaign_channel LIKE '%Social Media%')
                  AND child.close_date >= '02-16-2018'))

      ;
