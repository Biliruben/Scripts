package sailpoint.rule;

import sailpoint.object.Application;
import sailpoint.object.Link;
import sailpoint.object.Resolver;

public class Rule_CreateBogusLinks extends GenericRule {

    @Override
    public Object execute() throws Throwable {
        String LINK_ID = "2c9081c735abe63c0135abe70a1d0003";
        int dupes = 2000;
        int startElement = 1;
        int commitEvery = 20;
        
        Link patientZero = context.getObjectById(Link.class, LINK_ID);
        String originalId = patientZero.getNativeIdentity();
        
        // to truly be bogus, I want it associated to a bogus application
        Application originalApp = patientZero.getApplication();
        String bogusAppName = originalApp.getName() + " bogus";
        Application bogusApp = context.getObjectByName(Application.class, bogusAppName);
        if (bogusApp == null) {
            bogusApp = (Application) originalApp.deepCopy((Resolver)context);
            context.decache(); // purge the object copies I don't want
            originalApp.setScorecard(null);
            originalApp.setSchemas(null); // don't need'em
            bogusApp.setId(null);
            bogusApp.setName(bogusAppName);
        }

        context.saveObject(bogusApp);
        context.commitTransaction();
        
        for (int i = 0; i <= dupes; i++) {
            Link clone = (Link) patientZero.deepCopy((Resolver)context);
            clone.setId(null);
            clone.setNativeIdentity(originalId + startElement);
            clone.setApplication(bogusApp);
            startElement++;
            context.saveObject(clone);
            if (i % commitEvery == 0) {
                context.commitTransaction();
                context.decache();
            }
        }
        
        
        
        return null;
    }

}
