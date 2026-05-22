SET @captureId = '0af4040e95ca13328195cb751ba602b8';
delete from spt_hist_accounts where capture_id = @captureId;
delete from spt_hist_assigned_roles where capture_id = @captureId;
delete from spt_hist_detected_roles where capture_id = @captureId;
delete from spt_hist_entitlements where capture_id = @captureId;
delete from spt_hist_policy_violations where capture_id = @captureId;
delete from spt_hist_identity_capture where id = @captureId
