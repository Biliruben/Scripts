package sailpoint.rule;

import sailpoint.object.Permission;

public class Rule_RACFPermissionCustomization extends
        PermissionCustomizationRule {

    Permission doIt(Permission perm, String liner) {
        // easier to parse from the line, I think
        if (liner != null && liner.startsWith("0505")) {
            String className = liner.substring(253, 260).trim();
            if (!className.equals("")) {
                perm.setTarget(className + ":" + perm.getTarget());
            }
        }
        return perm;
    }
    
    @Override
    public Object execute() throws Throwable {
        return doIt(permission, line);
    }

}
