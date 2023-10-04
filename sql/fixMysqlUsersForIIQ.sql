-- SET @iiq_user = '638b896_1'@'localhost';
-- SET @iiq_user = '638b896_1';
-- SET @host_value = 'localhost';
-- SET @iiq_password = '638b896_1';
-- SET @create_query = 'CREATE USER IF NOT EXISTS @iiq_user IDENTIFIED WITH mysql_native_password BY @iiq_password';
SET @create_query = CONCAT ('CREATE USER IF NOT EXISTS "', @iiq_user, '"@"', @host_value, '" IDENTIFIED BY "', @iiq_password, '" ');
SET @grant_query = CONCAT ('GRANT ALL PRIVILEGES ON ', @iiq_user, '.* TO "', @iiq_user, '"@"', @host_value,'"');
SET @grant_plugin_query = CONCAT ('GRANT ALL PRIVILEGES ON ', @iiq_user, 'plugin.* TO "', @iiq_user, '"@"', @host_value,'"');
select @iiq_user, @iiq_password, @host_value;

select @create_query;
PREPARE createstmt from @create_query;
EXECUTE createstmt;
DEALLOCATE PREPARE createstmt;

select @grant_query;
PREPARE grantstmt from @grant_query;
EXECUTE grantstmt;
DEALLOCATE PREPARE grantstmt;

select @grant_plugin_query;
PREPARE grantpluginstmt from @grant_plugin_query;
EXECUTE grantpluginstmt;
DEALLOCATE PREPARE grantpluginstmt;
