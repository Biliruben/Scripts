-- SET @iiq_user = '638b896_1'@'localhost';
-- SET @iiq_user = '638b896_1';
-- SET @host_value = 'localhost';
-- SET @iiq_password = '638b896_1';
-- SET @create_query = 'CREATE USER IF NOT EXISTS @iiq_user IDENTIFIED WITH mysql_native_password BY @iiq_password';
SET @grant_plugin_query = CONCAT ('GRANT ALL PRIVILEGES ON ', @iiq_user, 'plugin.* TO "', @iiq_user, '"@"', @host_value,'"');
select @iiq_user, @iiq_password, @host_value;

select @grant_plugin_query;
PREPARE grantpluginstmt from @grant_plugin_query;
EXECUTE grantpluginstmt;
DEALLOCATE PREPARE grantpluginstmt;
