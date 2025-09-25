delete from spt_bundle_profile_relation_step;
delete from spt_bundle_profile_relation;
delete from spt_bundle_profile_relation_object;

/* Uncomment to also delete the roles */
/*
delete from spt_profile_constraints;
delete from spt_profile_permissions;
delete from spt_profile;
SET FOREIGN_KEY_CHECKS=0;
delete from spt_role_scorecard;
delete from spt_bundle_children;
delete from spt_role_index;
delete from spt_bundle;
SET FOREIGN_KEY_CHECKS=1;
*/