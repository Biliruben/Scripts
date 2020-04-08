SELECT
    5kident1500ent.acctId,
    5kident1500ent.empId,
    5kident1500ent.firstName,
    5kident1500ent.lastName,
    5kident1500ent.middleInit,
    5kident1500ent.title,
    5kident1500ent.region,
    5kident1500ent.department,
    5kident1500ent.email,
    group_concat(distinct 5kident1500ent.groups),
    group_concat(distinct 5kident1500entcity.location)
FROM
    5kident1500ent
JOIN
    5kident1500entcity
ON
    5kident1500ent.acctId = 5kident1500entcity.acctId
GROUP BY
    acctId limit 20;

