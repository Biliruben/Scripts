package sailpoint.rule;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Rule_RACFPreIterateRule extends PreIterateRule {

    @Override
    public Object execute() throws Throwable {
        String outputFileName = "racfOutput.txt";
        String inputFileName = (String) stats.get("absolutePath");
        
        // RACF Pre-Iterate that modifies all 0505 values to append the
        // class to the target name
        
        BufferedReader bin = new BufferedReader(new FileReader(inputFileName));
        BufferedWriter bout = new BufferedWriter(new FileWriter(outputFileName));
        
        Pattern fiveOhFive = Pattern.compile("^0505\\s.*"); // the line starts with "0505 "
        
        String line = bin.readLine();
        while (line != null) {
            Matcher m = fiveOhFive.matcher(line);
            if (m.matches()) {
                line = appendClass(line);
            }
            bout.write(line + "\n");
            line = bin.readLine();
        }
        bin.close();
        bout.flush();
        bout.close();
        
        // Preiterate needs to return an InputStream
        FileInputStream fis = new FileInputStream(outputFileName);
        return fis;
    }
    
    String appendClass(String permissionLine) {
        // one may find using LineRecord and LineRecordField to be
        // more preferable than this old 'n tired method
        if (permissionLine.length() > 260) {
            String targetName = permissionLine.substring(5,252);
            String targetClass = permissionLine.substring(252, 260);
            // converts the new name to 'oldName:class'.  Trims all the whitespace (we'll put it back)
            StringBuilder newTargetName = new StringBuilder(255);
            newTargetName.append(targetName.trim()).append(":").append(targetClass.trim());
            // pad the rest
            String paddedTargetName = String.format("%1$-247s", newTargetName.toString());
            
            // now replace the occurance of 'targetname[all spaces]' with 'newtargetnameWPadding'
            permissionLine = permissionLine.replace(targetName, paddedTargetName);
        }
        return permissionLine;
    }


    public static void main(String[] args) throws Throwable {
        Rule_RACFPreIterateRule r = new Rule_RACFPreIterateRule();
        r.stats = new HashMap();
        r.stats.put("absolutePath", "C:\\etn_data\\14446 - Racf Crap\\06112013\\all505Perms.txt");
        r.execute();
    }
}
