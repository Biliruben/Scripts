package sailpoint.rule;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;

public class Rule_TestPretIterate extends GenericRule {

    @Override
    public Object execute() throws Throwable {
        BufferedInputStream bis = new BufferedInputStream(new ByteArrayInputStream("this,that,fuck-a-doodle-do".getBytes()));
        
        return bis;
    }

}
