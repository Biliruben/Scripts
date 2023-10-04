package sailpoint.rule;

import sailpoint.object.Application;
import sailpoint.object.Resolver;

public class Rule_CreateBogusApplications extends GenericRule {

    @Override
    public Object execute() throws Throwable {
        // Gimmie an existing application id
        String APPLICATION_ID = "2c9081bb35c05e960135c0601c1c0004";
        int dupes = 15000;
        int startElement = 1;
        int commitEvery = 20;
        
        Application patientZero = context.getObjectById(Application.class, APPLICATION_ID);
        String originalName = patientZero.getName();
        
        // clone the application giving it an incremental name
        for (int i = 0; i <= dupes; i++) {
            Application clone = (Application) patientZero.deepCopy((Resolver)context);
            context.decache(); // purge unwanted cloned objects
            clone.setId(null); // make on on save?
            clone.setScorecard(null);
            clone.setName(originalName + startElement);
            context.saveObject(clone);
            startElement++;
            if (i % commitEvery == 0) {
                context.commitTransaction();
                context.decache();
            }
        } // do it 15k times

        context.commitTransaction();
        context.decache();

        return null;
    }

}
