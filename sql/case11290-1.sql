select * from ( 
	select managedatt0_.id as col_0_0_, 
		applicatio1_.description as col_1_0_, 
		applicatio1_.id as col_2_0_, 
		managedatt0_.type as col_3_0_, 
		managedatt0_.value as col_4_0_, 
		applicatio1_.name as col_5_0_, 
		managedatt0_.attribute as col_6_0_, 
		managedatt0_.displayable_name as col_7_0_, 
		identity2_.display_name as col_8_0_, 
		identity2_.name as col_9_0_, 
		managedatt0_.extended2 as col_10_0_ 
	from spt_managed_attribute managedatt0_ 
	left outer join spt_application applicatio1_ on managedatt0_.application=applicatio1_.id 
	left outer join spt_identity identity2_ on managedatt0_.owner=identity2_.id 
	
	where (
		upper(applicatio1_.name) like '%SERVER%' 
			or upper(managedatt0_.displayable_name) like '%SERVER%') 
		and managedatt0_.type='Entitlement' 
		and managedatt0_.requestable=1 
		and managedatt0_.type='Entitlement' 
	order by managedatt0_.displayable_name 
	) 
	
where rownum <= 10