-- ============================================================================
-- Script id: 17373711
-- Description: ETL for the Message Studio mailing rollup. Gets all the data
--              from the beginning of time.
-- ============================================================================

TRUNCATE TABLE wesna.ms_mailing_rollup;

INSERT INTO wesna.ms_mailing_rollup
(SELECT base_population.mailingid AS mailing_id,
        "target".target_count AS target_count,
        "sent".sent_count AS sent_count,
        deferment_failures.defer_fail_count AS defer_fail_count,
        delivered.delivered_count AS delivered_count,
        unique_opens.unique_opens_count AS unique_opens_count,
        unique_clicks.unique_clicks_count AS unique_clicks_count,
        total_opens.total_opens_count AS total_opens_count,
        total_clicks.total_clicks_count AS total_clicks_count,
        unsubscribes.unsubscribes_count AS unsubscribes_count,
        hard_bounces.hard_bounces_count AS hard_bounces_count,
        soft_bounces.soft_bounces_count AS soft_bounces_count
   FROM (SELECT mailingid
           FROM message_studio.v_sm_aggregate_log
          GROUP BY mailingid
   ) AS base_population
   LEFT JOIN (SELECT mailingid,
                     sum(cnt) target_count -- Target count
                FROM (SELECT mailingid,
                             count(1) cnt -- Success and defer-success count
                        FROM message_studio.v_sm_success_log
                       GROUP BY mailingid
                       UNION ALL
                      SELECT mailingid,
                             count(1) cnt -- Invalid count
                        FROM message_studio.v_sm_aggregate_log
                       WHERE logtype = 3 -- Invalid
                       GROUP BY mailingid
                )
               GROUP BY mailingid
   ) AS "target" ON base_population.mailingid = "target".mailingid -- target
   LEFT JOIN (SELECT mailingid,
                     sum(cnt) sent_count -- Sent count
                FROM (SELECT mailingid,
                             count(1) cnt -- Failed count
                        FROM message_studio.v_sm_aggregate_log
                       WHERE logtype = 1  -- "Failed"
                       GROUP BY mailingid
                       UNION ALL
                      SELECT mailingid,
                             count(1) cnt -- Success and defer-success count
                        FROM message_studio.v_sm_success_log
                       GROUP BY mailingid
                       UNION ALL
                      SELECT mailingid,
                             count(1) cnt -- Defer-failed count
                        FROM message_studio.v_sm_aggregate_log
                       WHERE logtype = 2  -- "Defer-failed"
                       GROUP BY mailingid
                )
               GROUP BY mailingid
   ) AS "sent" ON base_population.mailingid = "sent".mailingid
   JOIN (SELECT mailingid,
                count(1) defer_fail_count -- Defer-failed count
           FROM message_studio.v_sm_aggregate_log
          WHERE logtype = 2  -- Defer-failed
          GROUP BY mailingid
   ) AS deferment_failures ON base_population.mailingid = deferment_failures.mailingid
   JOIN (SELECT mailingid,
                count(1) delivered_count -- Deliver count
           FROM message_studio.v_sm_success_log
          GROUP BY mailingid
   ) AS delivered ON base_population.mailingid = delivered.mailingid
   JOIN (SELECT mailingid, 
                count(distinct(email_sha)) unique_opens_count -- Unique open count
           FROM message_studio.v_sm_tracking_log
          WHERE ttype = 'open'
          GROUP BY mailingid
   ) AS unique_opens ON base_population.mailingid = unique_opens.mailingid
   JOIN (SELECT mailingid, 
                count(distinct(email_sha)) unique_clicks_count -- Unique click count
           FROM message_studio.v_sm_tracking_log
          WHERE ttype = 'click'
          GROUP BY mailingid
   ) AS unique_clicks ON base_population.mailingid = unique_clicks.mailingid
   JOIN (SELECT mailingid, 
                count(1) total_opens_count -- Total opens count
           FROM message_studio.v_sm_tracking_log
          WHERE ttype = 'open'
          GROUP BY mailingid
   ) AS total_opens ON base_population.mailingid = total_opens.mailingid
   JOIN (SELECT mailingid, 
               count(1) total_clicks_count -- Total clicks count
          FROM message_studio.v_sm_tracking_log
         WHERE ttype = 'click'
         GROUP BY mailingid
   ) AS total_clicks ON base_population.mailingid = total_clicks.mailingid
   JOIN (SELECT mailingid,
                count(distinct(email_sha)) unsubscribes_count -- Unique Unsubscribe count
           FROM message_studio.v_sm_aggregate_log
          WHERE logtype = 7  -- "Unsubscribe log"
          GROUP BY mailingid
   ) AS unsubscribes ON base_population.mailingid = unsubscribes.mailingid
   JOIN (SELECT mailingid,
                count(distinct(email_sha)) hard_bounces_count -- Hard bounces
           FROM message_studio.v_sm_aggregate_log						
          WHERE logtype = 4 -- "Bounce mailbox"
            AND category = 2 -- "Hard bounce"
          GROUP BY mailingid
   ) AS hard_bounces ON base_population.mailingid = hard_bounces.mailingid
   JOIN (SELECT mailingid,
                count(distinct(email_sha)) soft_bounces_count -- Soft bounces
           FROM message_studio.v_sm_aggregate_log						
          WHERE logtype = 4 -- "Bounce mailbox"
            AND category = 3 -- "Soft bounce"
          GROUP BY mailingid
   ) AS soft_bounces ON base_population.mailingid = soft_bounces.mailingid
 )
;
