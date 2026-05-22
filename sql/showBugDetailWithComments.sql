SET @query = 'SELECT
    longdescs.bug_id,
    -- longdescs.who,
    profiles.login_name,
    longdescs.work_time,
    longdescs.thetext,
    CHAR(10)
FROM
    longdescs
left join profiles on profiles.userid = longdescs.who
WHERE
    longdescs.bug_id = @bugId
ORDER BY
    longdescs.comment_id';

PREPARE stmt from @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
