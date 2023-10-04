package sailpoint.rule;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import sailpoint.object.Filter;
import sailpoint.object.Identity;
import sailpoint.object.Link;
import sailpoint.object.QueryOptions;

/**
 * Given an Identity, this rule migrates all links in the system to this Identity.  Cheap way to create Identities with "lots" of links using
 * just demo data
 * @author trey.kirk
 *
 */
public class Rule_MigrateAllLinks extends GenericRule {

    @Override
    public Object execute() throws Throwable {
        /* Identity Name */
        String identityName = "Angela.Bell";
        int commitEvery = 20;
        
        // Get Identity
        Identity migrateTo = context.getObjectByName(Identity.class, identityName);
        
        // Get list of Link ids NOT already associated to the Identity
        QueryOptions opts = new QueryOptions();
        Filter f = Filter.ne("identity", migrateTo);
        List filters = new ArrayList();
        filters.add(f);
        opts.setRestrictions(filters);
        opts.setDistinct(true);
        List projection = new ArrayList();
        projection.add("id");
        Iterator results = context.search(Link.class, opts, projection);
        // results is an Iterator of String[], but generic-less bean shell hides that from me
        int count = 0;
        // pretty sure I'll need this
        // Identitizer swizzler = new Identitizer(context);
        // actually, probably not.  I'm not interested in refreshing now.  I'm happy to do that as a post-process activity
        while (results.hasNext()) {
            Object[] nextO = (Object[]) results.next();
            String linkId = (String)nextO[0];
            Link nextLink = context.getObjectById(Link.class, linkId);
            if (nextLink != null) {
                // got one, so some work
                count++;
                nextLink.setIdentity(migrateTo);
                migrateTo.add(nextLink);
                // Migrate each Link, committing, clearing, and refetching identity as we go
                context.saveObject(nextLink);
            }
            if (count % commitEvery == 0) {
                context.commitTransaction();
                context.decache();
                // put the Identity back in the pile
                context.attach(migrateTo);
            }
        }
        
        // final commit
        context.commitTransaction();
        context.decache();
        
        // this may create IDX issues, fix'em
        // ...manually :-D
        
        return "Migrated " + count + " links";
    }

}
