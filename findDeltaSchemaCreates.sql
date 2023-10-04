select a.created, s.created, s.created - a.created as deltaCreated, a.name from spt_application a
join spt_application_schema s on a.id = s.application 
order by deltaCreated
