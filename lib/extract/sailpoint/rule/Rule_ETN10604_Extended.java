package sailpoint.rule;

import sailpoint.api.ObjectUtil;
import sailpoint.api.PersistenceManager;
import sailpoint.api.Terminator;
import sailpoint.object.Certification;
import sailpoint.object.Identity;
import sailpoint.object.Scorecard;
import sailpoint.tools.Util;

public class Rule_ETN10604_Extended extends GenericRule {

    @Override
    public Object execute() throws Throwable {
        // Trying the following pattern:
        /*
         * - Get child of parent where child is 1..*
         * - Get parent
         * - Lock parent
         * - Get parent.children.child
         * - Delete child via Terminator
         */
        
        // First test: CertificationEntity v. Certification
        // item: 2c9081b8363614e601363617d3a90010
        // item.entity: 2c9081b8363614e601363617d3a5000a
        // Result: no error -- pattern must include 'parent.getChildren()', and it does not
        
        // Certification v. Certification might
        // child: 2c9081b8363614e601363617e0130072
        // child.parent: 2c9081b8363614e601363617d6280027
        // Result: boom
        /*
        String CHILD_ID = "2c9081b8363614e601363617e0130072";
        String PARENT_ID = "2c9081b8363614e601363617d6280027";
        
        // get child
        Certification child = context.getObjectById(Certification.class, CHILD_ID);
        
        // get parent
        Certification parent = context.getObjectById(Certification.class, PARENT_ID);
        
        // lock parent
        parent = ObjectUtil.lockObject(context, Certification.class, PARENT_ID, null, PersistenceManager.LOCK_TYPE_PERSISTENT, Util.uuid(), ObjectUtil.DEFAULT_LOCK_TIMEOUT);
        
        // get parent.children.child
        Certification child2 = parent.getCertification(CHILD_ID);
        
        // Delete child
        try {
            // unspoken here is typically parent.removeChild(child).  Don't believe it's relevant for the demonstration
            Terminator t = new Terminator(context);
            t.setNoDecache(true);
            t.deleteObject(child2);

        } catch (Throwable t) {
            log.error("Couldn't delete child", t);
        }
        context.rollbackTransaction();
        ObjectUtil.unlockObject(context, parent, PersistenceManager.LOCK_TYPE_PERSISTENT);
        // put it back
        parent.add(child2);
        return null;         
         */
        
        // Cert v. Cert confirms the originally stated pattern.  What about removing the middle layer of 
        // child collections and instead access the evicted object only
        // Scorecard v. Identity
        // child: 2c9081b83640b456013640c20fcd00c8 -- scorecard
        // parent: 2c9081c7361328dc013613295dde000a -- identity
        // Result: works fine -- child2 is a CGLibed object and not the cached instance.  The cached one was evicted with
        //      the parent, as desired.
        String CHILD_ID = "2c9081b83640b456013640c20fcd00c8";
        String PARENT_ID = "2c9081c7361328dc013613295dde000a";
        
        // get child
        Scorecard child = context.getObjectById(Scorecard.class, CHILD_ID);
        
        // get parent
        Identity parent = context.getObjectById(Identity.class, PARENT_ID);
        
        // lock parent
        parent = ObjectUtil.lockObject(context, Identity.class, PARENT_ID, null, PersistenceManager.LOCK_TYPE_PERSISTENT, Util.uuid(), ObjectUtil.DEFAULT_LOCK_TIMEOUT);
        
        // get parent.children.child
        Scorecard child2 = parent.getScorecard();
        
        // Delete child
        try {
            // unspoken here is typically parent.removeChild(child).  Don't believe it's relevant for the demonstration
            Terminator t = new Terminator(context);
            t.setNoDecache(true);
            t.deleteObject(child2);

        } catch (Throwable t) {
            log.error("Couldn't delete child", t);
        }
        context.rollbackTransaction();
        ObjectUtil.unlockObject(context, parent, PersistenceManager.LOCK_TYPE_PERSISTENT);
        // put it back
        //parent.add(child2);
        parent.setScorecard(child2);
        return null;
    }

}
