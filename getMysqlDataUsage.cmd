@echo off
mysql -e "select table_schema, sum(data_length + index_length) / 1024 / 1024 from information_schema.tables group by table_schema;"
