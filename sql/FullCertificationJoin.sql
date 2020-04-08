-- Full cert to cert action join query
select 
spt_certification_action.id as actionId,
spt_certification_item.id as itemId,
spt_certification_entity.id as entityId,
spt_certification.id as certId
from spt_certification_action 
left outer join spt_work_item on spt_certification_action.work_item = spt_work_item.id
left outer join spt_identity as owner on spt_work_item.owner = owner.id
left outer join spt_certification_item on spt_certification_item.action = spt_certification_action.id
left outer join spt_certification_entity on spt_certification_item.certification_entity_id = spt_certification_entity.id
left outer join spt_identity as targetEntity on spt_certification_entity.target_id = targetEntity.id
left outer join spt_certification on spt_certification_entity.certification_id = spt_certification.id
