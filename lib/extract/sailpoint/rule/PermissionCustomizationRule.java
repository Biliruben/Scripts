package sailpoint.rule;

import sailpoint.object.Attributes;
import sailpoint.object.Permission;

public abstract class PermissionCustomizationRule extends GenericRule {
    
    protected Permission permission;
    protected String line;
    
    @Override
    public void preExecute(Attributes<String, Object> attrs) {
        // TODO Auto-generated method stub
        super.preExecute(attrs);
        permission = (Permission)attrs.get("permission");
        line = (String)attrs.get("line");
    }

}
