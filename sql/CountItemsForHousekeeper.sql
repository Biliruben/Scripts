select
    count(distinct spt_certification.id) as unfinishedCertifications,
    count(distinct spt_certification_action.id) as remediations
from spt_certification
join spt_certification_entity on spt_certification.id = spt_certification_entity.certification_id
join spt_certification_item on spt_certification_entity.id = spt_certification_item.certification_entity_id
join spt_entitlement_snapshot on spt_certification_item.exception_entitlements = spt_entitlement_snapshot.id
join spt_certification_action on spt_certification_item.action = spt_certification_action.id
where spt_certification_action.status = 'Remediated'
        and spt_certification.finished is null 
        and spt_certification.signed is not null;
