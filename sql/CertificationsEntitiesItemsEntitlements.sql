select count(spt_certification_item.id)
from spt_certification_item
join spt_certification_action on spt_certification_item.action = spt_certification_action.id
where spt_certification_action.remediation_kicked_off = true;