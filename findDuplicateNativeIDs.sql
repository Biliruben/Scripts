 select i.id, l.native_identity, count(*) from iiq81p_z5444.spt_identity i

    join iiq81p_z5444.spt_link l on l.identity_id = i.id
    join iiq81p_z5444.spt_application a on l.application = a.id
   
    where a.name = '180k jdbc'
    group by i.id, l.native_identity
having count(*) > 0
