package sailpoint.rule;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import sailpoint.api.ObjectUtil;
import sailpoint.api.Terminator;
import sailpoint.object.Application;
import sailpoint.object.Filter;
import sailpoint.object.Identity;
import sailpoint.object.Link;
import sailpoint.object.QueryOptions;
import sailpoint.tools.GeneralException;

public class Rule_Scratch extends GenericRule {

    /*
     * rolling our own getLink as Identity#getLink is annoying and changing that in a patch is mean
     */
    private Link getLink (Identity identityObj, Application app, String instance, String identity) throws GeneralException {
        // start with a list of links for the application
        List links = getLinks(identityObj, app, instance);
        Link foundLink = null;
        Link foundDisplayNameLink = null;
        for (Object o : links) {
            Link link = (Link)o;
            if (identity == null ||
                    identity.equals(link.getNativeIdentity())) {
                foundLink = link;
                
                break;
            }
            else if (identity.equals(link.getDisplayName())) {
                if (foundDisplayNameLink == null)
                    foundDisplayNameLink = link;
            }
        }
        // per the contract with Identity#getLink(App, instance, identity), we have to match
        // nativeIdentity and then display name
        if (foundLink == null) {
            foundLink = foundDisplayNameLink; // if foundDispNameLink is still null, null begets null
        }
        return foundLink;
    }


    /*
     * rolling our own getLink as Identity#getLinks is annoying and changing that in a patch is mean
     */
    private List<Link> getLinks(Identity identity, Application app, String instance) throws GeneralException {

        if (identity.getId() != null) {
            // Instead of using Identity#getLinks(Application), we'll instead
            // build our own list appropriately scoped.
            // Since we're not terribly interested in the instance, querying works better for us
            QueryOptions options = new QueryOptions();
            options.add(Filter.eq("application", app));
            options.add(Filter.eq("identity", identity));

            Iterator<Link> iter = context.search(Link.class, options); // still not thrilled about this, but better than loading all links
            List<Link> links = new ArrayList<Link>();                   // - If we can remove the need for a Link object, we can go pure projection searching 
            while (iter.hasNext()) {
                Link nextLink = iter.next();
                if (instance != null && instance.equals(nextLink.getInstance()) || instance == null) {
                    links.add(nextLink);  
                }
            }
            return links;
        } else {
            // During a provisioning plan compile for a role, a stub Identity is provided.  When that happens, just defer
            // to the objects accessor instead of searching in Hibernate
            List<Link> links = identity.getLinks(app);
            if (links == null) {
                links = new ArrayList<Link>(); // don't like returning null
            }
            return links;
        }

    }

    @Override
    public Object execute() throws Throwable {

        // The theory to prove is that given IdentityA, will searching for a link cause the link to remain in the hibernate
        // cache resulting in a new instantion of IdentityA getting a reference to the link when pulling the link out of the new 
        // object's list

        /*
         * So the test is:
         * - Get an Identity
         * - Search for a link from the Identity
         * - Fetch the same Identity, via by name?
         * - fetch the same link via getLinks
         */

        String APPLICATION_NAME = "Active_Directory";
        String NATIVE_IDENTITY = "JamesSmith";
        String IDENTITY_ID = "2c9081c73613277101361328a99b041a";
        Application app = context.getObjectByName(Application.class, APPLICATION_NAME);

        // first 'get' is via id
        Identity identity = context.getObjectById(Identity.class, IDENTITY_ID);
        Link l1 = getLink(identity, app, null, NATIVE_IDENTITY);

        // lock it, makes a new object
        Identity identity2 = ObjectUtil.lockIdentity(context, identity);
        // fetch the link via getLinks
        Link l2 = identity2.getLink(app);

        // Remove Link 2 from Identity 2, this should be Kosher
        String msg = "Everything worked fine!";
        try {

            Terminator t = new Terminator(context);
            t.setNoDecache(true);
            t.deleteObject(l2);

            context.commitTransaction();
        } catch (Exception e) {
            log.error("Error removing link from Identity", e);
            msg = e.getMessage();
        }

        ObjectUtil.unlockIdentity(context, identity);

        return msg;

    }

}
