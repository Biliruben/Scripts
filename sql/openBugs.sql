SELECT
    bug_id,
    bug_status
FROM
    bugs
JOIN
    profiles
ON
    profiles.userid = bugs.assigned_to
WHERE
    profiles.login_name = 'trey.kirk@sailpoint.com'
AND (
        bugs.bug_status = 'ASSIGNED'
    OR  bugs.bug_status = 'NEW'
    OR  bugs.bug_status = 'REOPENED')
