SELECT
    COUNT(t1.id)
FROM
    spt_hist_entitlement_capture t1
INNER JOIN
    (
        SELECT
            hec.identity_entitlement_id,
            MAX(hec.effective_date) max_date
        FROM
            spt_hist_entitlement_capture hec
        WHERE
            hec.effective_date <= :date
        AND hec.identity_entitlement_id IN
            (
                SELECT
                    he.identity_entitlement_id
                FROM
                    spt_hist_entitlements he
                WHERE
                    he.capture_id = :captureId)
        AND hec.attribute_name NOT IN ('detectedRoles',
                                       'assignedRoles')
        GROUP BY
            hec.identity_entitlement_id ) t2
ON
    t1.identity_entitlement_id = t2.identity_entitlement_id
AND t1.effective_date = t2.max_date