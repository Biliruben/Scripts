select 
--count(distinct spt_certification.id),
distinct spt_certification.id,
CURTIME()
from spt_certification
join spt_certification_entity on spt_certification_entity.certification_id = spt_certification.id
join spt_certification_item on spt_certification_item.certification_entity_id = spt_certification_entity.id
where spt_certification_item.summary_status = 'Complete'
limit 10;