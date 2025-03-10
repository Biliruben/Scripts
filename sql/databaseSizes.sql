SELECT table_schema "Data Base Name",
    sum( data_length + index_length ) / 1024 / 1024 as totalSize,
    sum( data_free )/ 1024 / 1024 "Free Space in MB"
FROM information_schema.TABLES
GROUP BY table_schema
order by totalSize asc;
