select 
spt_identity_history.id,
spt_identity_history_item.*

from spt_identity_history
join spt_identity_history_item on spt_identity_history.id = spt_identity_history_item.identity_history_id
order by
    spt_identity_history_item.entry_date,
    spt_identity_history_item.native_identity,
    spt_identity_history_item.application,
    spt_identity_history_item.attribute,
    spt_identity_history_item.value,
    spt_identity_history_item.actor,
    spt_identity_history_item.created,
    spt_identity_history_item.id
