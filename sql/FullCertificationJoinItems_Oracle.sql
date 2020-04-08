-- Full cert to cert action join query
select 
spt_certification_item.id as itemId,
spt_certification_entity.id as entityId,
spt_certification.id as certId
from spt_certification_item 
left outer join spt_certification_item on spt_certification_item.action = spt_certification_action.id
left outer join spt_certification_entity on spt_certification_item.certification_entity_id = spt_certification_entity.id
left outer join spt_certification on spt_certification_entity.certification_id = spt_certification.id
