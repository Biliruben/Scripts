DECLARE @i INT = 1

DECLARE @resultTable TABLE
(
   iteration DATETIME,
   freePages int,
   freeSpace int
)

-- in seconds
WHILE (@i <= 150)
 BEGIN
  WAITFOR DELAY '00:00:01'
      INSERT INTO @resultTable
      SELECT GETDATE(), 
         SUM(unallocated_extent_page_count) AS [freePages],
        (SUM(unallocated_extent_page_count)*1.0/128) AS [freeSpace]
                FROM tempdb.sys.dm_db_file_space_usage
 SET  @i = @i + 1
END
SELECT * FROM @resultTable
