SET @query = 'SELECT
    longdescs.bug_id,
    longdescs.work_time,
    longdescs.thetext
FROM
    longdescs
WHERE
    longdescs.bug_id = @bugId
ORDER BY
    longdescs.comment_id';

PREPARE stmt from @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
