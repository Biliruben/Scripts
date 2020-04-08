SET @query = 'SELECT
    bugs.bug_id,
    target_patch.milestone,
    bugs.target_milestone,
    bugs.short_desc
FROM
    bugs
JOIN
    profiles
ON
    profiles.userid = bugs.assigned_to
LEFT JOIN
    target_patch
ON
    target_patch.bug_id = bugs.bug_id
WHERE
    bugs.bug_id = @bugId
ORDER BY
    bugs.bug_id,
    target_patch.milestone';
PREPARE stmt from @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
