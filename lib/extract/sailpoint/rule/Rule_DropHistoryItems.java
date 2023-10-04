package sailpoint.rule;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import sailpoint.object.Filter;
import sailpoint.object.IdentityHistoryItem;
import sailpoint.object.QueryOptions;

public class Rule_DropHistoryItems extends GenericRule {

    @Override
    public Object execute() throws Throwable {
        int decacheEvery = 20;
        
        // get all IdentityHistoryItem objects that are decisions
        QueryOptions opts = new QueryOptions();
        List filters = new ArrayList();
        filters.add(Filter.notnull("action"));
        filters.add(Filter.eq("type", IdentityHistoryItem.Type.Decision));
        opts.setRestrictions(filters);
        opts.setDistinct(true);
        
        Iterator results = context.search(IdentityHistoryItem.class, opts, "id");
        int count = 0;
        
        // if they have an Action, make go bye-bye
        while (results.hasNext()) {
            count++;
            Object[] nextRes = (Object[])results.next();
            String id = (String) nextRes[0];
            IdentityHistoryItem item = context.getObjectById(IdentityHistoryItem.class, id);
            if (log.isDebugEnabled()) {
                log.debug("Messing with: " + item);
            }
            item.setAction(null);
            context.saveObject(item);
            if (count % decacheEvery == 0) {
                log.warn("Processed " + count + " items");
                context.commitTransaction();
                context.decache();
            }
        }
        // one last commit, decache, and only if we didn't just do it
        if (count % decacheEvery != 0) {
            log.warn("Processed " + count + " items");
            context.commitTransaction();
            context.decache();
        }
        
        return count;
    }

}
