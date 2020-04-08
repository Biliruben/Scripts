select
    spt_certification.id as certId,
    spt_certification.name as certName,
    spt_certification_entity.id as entityId,
    spt_entitlement_snapshot.id as entSnapshotId,
    count(spt_certification_item.id) as itemCount
from spt_certification
join spt_certification_entity on spt_certification.id = spt_certification_entity.certification_id
join spt_certification_item on spt_certification_entity.id = spt_certification_item.certification_entity_id
join spt_entitlement_snapshot on spt_certification_item.exception_entitlements = spt_entitlement_snapshot.id
where spt_certification.name = 'Identity Access Review for Adam Kennedy'
group by spt_certification_entity.id, spt_certification.id, spt_certification.name
order by itemCount desc
