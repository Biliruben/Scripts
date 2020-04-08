select spt_bundle.name, 
    spt_bundle.type,
    childName.name
from spt_bundle
join spt_bundle_children on spt_bundle_children.bundle = spt_bundle.id
join spt_bundle as childName on spt_bundle_children.child = childName.id;