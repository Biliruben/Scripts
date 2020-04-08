--select spt_work_item.id, spt_work_item.name from spt_work_item 
--where spt_work_item.description is null;

-- 2c9084ab350c97a201350ce71cec065b
select 
--spt_certification_action.id, spt_certification_action.description 
spt_certification.id as certId,
spt_certification_action.id as actionId,
spt_certification_action.description as actionDesc,
spt_certification_action.owner as actionOwner,
spt_identity.name as workItemOwnerName,
spt_certification_action.work_item as actionWi,
spt_certification_action.bulk_certified as actionBulk,
spt_certification_action.actor_display_name as actionActor,
spt_certification_action.decision_date as actionDate
from spt_certification_action 
join spt_work_item on spt_certification_action.work_item = spt_work_item.id
join spt_identity on spt_work_item.owner = spt_identity.id
join spt_certification_item on spt_certification_item.action = spt_certification_action.id
join spt_certification_entity on spt_certification_item.certification_entity_id = spt_certification_entity.id
join spt_certification on spt_certification_entity.certification_id = spt_certification.id
where spt_work_item.description is null;