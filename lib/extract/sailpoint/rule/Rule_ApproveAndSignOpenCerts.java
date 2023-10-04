package sailpoint.rule;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.util.Set;

import sailpoint.api.Certificationer;
import sailpoint.api.certification.RemediationManager;
import sailpoint.object.AbstractCertificationItem;
import sailpoint.object.Certification;
import sailpoint.object.CertificationAction;
import sailpoint.object.CertificationItem;
import sailpoint.object.Filter;
import sailpoint.object.Identity;
import sailpoint.object.QueryOptions;



public class Rule_ApproveAndSignOpenCerts extends GenericRule {

    public boolean terminate() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public Object execute() throws Throwable {

        int SAVE_EVERY = 100;
        boolean SKIP_DECISIONS = true;
        boolean revokeInstead = true;
        int percentRevoke = 50;

        Identity approver = context.getObjectByName(Identity.class, "spadmin");
        RemediationManager remedMgr = new RemediationManager(this.context);
        Random rand = new Random(new Date().getTime());

        Certificationer certificationer = new Certificationer(context);
        List filters = new ArrayList();
        Iterator results = null;
        List properties = new ArrayList();
        properties.add("id");
        // Find open items, approve them
        // Criteria: items that are open for certs that are not complete
        if (!SKIP_DECISIONS) {
            filters.add(Filter.eq("parent.certification.complete", false));
            filters.add(Filter.eq("summaryStatus", AbstractCertificationItem.Status.Open));
            QueryOptions itemOpts = new QueryOptions();
            itemOpts.setRestrictions(filters);
            results = context.search(CertificationItem.class, itemOpts, properties);
            List itemIds = new ArrayList();

            // Copy the results from the result set and into the JVM
            while (results.hasNext()) {
                Object[] objArray = (Object[])results.next();
                String id = (String)objArray[0];
                itemIds.add(id);
            }

            // For every item we approve, we'll need to refresh the owning certification.  Create
            // a Set for the cert ids and refresh them after approval
            Set certs = new HashSet();
            int counter = 0;
            log.warn("Actioning certItem from results: " + results);
            for (Object objId : itemIds) {
                String id = (String) objId;
                log.trace("Actioning item: " + id);
                CertificationItem item = context.getObjectById(CertificationItem.class, id);
                counter++;
                String certId = item.getCertification().getId();
                certs.add(certId);
                if (revokeInstead && rand.nextInt(100) <= percentRevoke) {
                    log.trace("Revoking item: " + id);
                    CertificationAction.RemediationAction remediationAction = CertificationAction.RemediationAction.OpenWorkItem;
                    item.remediate(context, approver, null, remediationAction, approver.getName(), "Do EET!", null, null, null);
                } else {
                    log.trace("Approving item: " + id);
                    item.approve(context, approver, null);
                }

                if (counter % SAVE_EVERY == 0) {
                    log.warn(counter + " processed...");
                    context.commitTransaction();
                    context.decache();
                }
            }

            // save
            context.commitTransaction();
            context.decache();

            // Refresh certs
            log.warn("Refreshing certs...");
            for (Object objId : certs) {
                String certId = (String)objId;
                Certification cert = context.getObjectById(Certification.class, certId);
                log.warn("Refreshing cert: " + cert);
                if (cert != null) {
                    certificationer.refresh(cert);
                    // save
                    context.commitTransaction();
                    context.decache();
                }
            }

        }
        // Find open certs, sign them
        log.warn("Signing certs...");
        filters = new ArrayList();
        filters.add(Filter.isnull("signed"));
        filters.add(Filter.eq("complete", true));
        QueryOptions certOpts = new QueryOptions();
        certOpts.setRestrictions(filters);
        results = context.search(Certification.class, certOpts, properties);
        log.warn("Processing certification results: " + results);

        // Copy the results from the result set and into the JVM
        List certIds = new ArrayList();
        while (results.hasNext()) {
            Object[] objArray = (Object[])results.next();
            String id = (String)objArray[0];
            certIds.add(id);
        }

        for (Object objId : certIds) {
            String id = (String)objId;
            log.warn("Signing cert: " + id);
            Certification cert = context.getObjectById(Certification.class, id);
            certificationer.sign(cert, approver);
            context.commitTransaction();
            context.decache();
        }

        context.commitTransaction();
        context.decache();

        return null;
    }

}
