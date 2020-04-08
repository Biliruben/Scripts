select id, name, entitlement_granularity
from spt_certification
where entitlement_granularity != "Value"

select id, name
from spt_configuration
where attributes like '%<entry key="additionalEntitlementGranularity" value="Application"/>%'
or attributes like '%<entry key="additionalEntitlementGranularity" value="Attribute"/>%';


select id, name
from spt_certification_definition
where attributes like '%<entry key="entitlementGranularity" value="Application"/>%'
or attributes like '%<entry key="entitlementGranularity" value="Attribute"/>%';
