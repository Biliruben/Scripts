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
    -- one could add 'FIXED' to this list but I don't feel that counts as closed
        bugs.bug_status = 'CLOSED'
    OR  bugs.bug_status = 'VERIFIED')
