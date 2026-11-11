SET @query = 'SELECT
    longdescs.bug_id,
    bs.value,
    longdescs.thetext
FROM
    longdescs
join bugs b on longdescs.bug_id = b.bug_id
join bug_status bs on b.bug_status = bs.id
WHERE
    longdescs.bug_id = @bugId
ORDER BY
    longdescs.comment_id
LIMIT
    1';
PREPARE stmt from @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
