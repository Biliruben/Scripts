delete from qrtz_job_details;
insert into qrtz_job_details (JOB_NAME, JOB_GROUP, DESCRIPTION, JOB_CLASS_NAME, IS_DURABLE, IS_VOLATILE, IS_STATEFUL, REQUESTS_RECOVERY, JOB_DATA) 
values ('Perform maintenance', 'DEFAULT', 'Perform maintenance every five minutes.', 'sailpoint.scheduler.SailPointJobFactory', '1', '0', '1', '0', '#
#Thu Sep 01 10:19:38 CDT 2011
executor=Perform Maintenance'
);

insert into qrtz_triggers     (TRIGGER_NAME,     TRIGGER_GROUP,     JOB_NAME,     JOB_GROUP,     IS_VOLATILE,     DESCRIPTION,     NEXT_FIRE_TIME,     PREV_FIRE_TIME,     PRIORITY,     TRIGGER_STATE,     TRIGGER_TYPE,     START_TIME,     END_TIME,     CALENDAR_NAME,     MISFIRE_INSTR,     JOB_DATA) 
values ('Raw Test 1', 'DEFAULT', 'Perform maintenance', 'DEFAULT', '0', 
    null, 1347642040000, 1316019640000, 5, 'WAITING', 'CRON', 1316019640000, 
    0, null, 0, null);

