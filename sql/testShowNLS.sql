select * from nls_session_parameters
select * from nls_instance_parameters
select * from nls_database_parameters

alter session set NLS_COMP='LINGUISTIC'
alter session set NLS_SORT='BINARY_CI'

alter session set NLS_COMP='BINARY'
alter session set NLS_SORT='BINARY'

select distinct spt_identity.id from spt_identity where (spt_identity.workgroup in (0,1)) and (upper(spt_identity.firstname) like 'SPADMIN%' or upper(spt_identity.lastname) like 'SPADMIN%' or upper(spt_identity.name) like 'SPADMIN%')
select distinct spt_identity.id from spt_identity where (spt_identity.workgroup in (0,1)) and (upper(spt_identity.firstname) = 'SPADMIN%' or upper(spt_identity.lastname) = 'SPADMIN%' or upper(spt_identity.name) = 'SPADMIN%')

select distinct spt_identity.id from spt_identity where (spt_identity.workgroup in (0,1)) and (spt_identity.firstname like 'spadmin%' or spt_identity.lastname like 'spadmin%' or spt_identity.name like 'spadmin%')