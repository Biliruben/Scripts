package sailpoint.rule;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.util.Map;

import sailpoint.object.Application;
import sailpoint.object.Attributes;
import sailpoint.object.Schema;


public abstract class PreIterateRule extends GenericRule {

    protected Application application;
    /*
     *           A map passed by the connector of the stats for the file about to be iterated.
          Contains keys:
            fileName : (String) filename of the file about to be processed
            absolutePath : (String) absolute filename
            length : (Long) length in bytes
            lastModified : (Long) last time the file was updated Java GMT
     */
    protected Map stats;
    protected Schema schema;
    
    @Override
    public void preExecute(Attributes<String, Object> attrs) {
        super.preExecute(attrs);
        application = (Application) attrs.get("application");
        stats = (Map)attrs.get("stats");
        schema = (Schema)attrs.get("schema");
    }
        

}
