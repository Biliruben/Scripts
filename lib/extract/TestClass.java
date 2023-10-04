import java.util.ArrayList;
import java.util.List;

import sailpoint.object.TaskResult;


public class TestClass {

    /**
     * @param args
     */
    public static void main(String[] args) {
        String _source = ".\\.App\\.Tier1.bizDig\\.fart\\.stomper.howdThis\\.getHere\\.";
        List<String> componentTokens = new ArrayList<String>();
        String[] tokens = _source != null ? _source.split("\\.") : null;
        StringBuilder builder = new StringBuilder();
        for (int i = 0; tokens != null && i < tokens.length; i++) {
            // does the token end with a '\'?
            String token = tokens[i];
            if (token.endsWith("\\")) {
                // it's an escapee
                builder.append(token.substring(0, token.length() - 1)).append(".");
                if (i == tokens.length - 1) {
                    // last token, make sure to add to the list
                    componentTokens.add(builder.toString());
                }
            } else {
                // true delimeter
                builder.append(token);
                componentTokens.add(builder.toString());
                builder = new StringBuilder();
            }
        }
        System.out.println(componentTokens);
        Class c = TaskResult.class;
    }

}
