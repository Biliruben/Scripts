SET @query = 'SELECT
    longdescs.bug_id,
    longdescs.thetext
FROM
    longdescs
WHERE
    longdescs.bug_id = @bugId
ORDER BY
    longdescs.comment_id
LIMIT
    1';
PREPARE stmt from @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
