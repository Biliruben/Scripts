package sailpoint.services.log.api;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class LogFormatter extends AbstractTraceAspectLogAnalyzer {

    private static final String INDENT = "   ";
    private List<String> _msgs;

    public LogFormatter(String layoutPattern) {
        super(layoutPattern);
        _msgs = new ArrayList<String>();
    }

    @Override
    public void addLogEvent(String logEvent) {
        super.addLogEvent(logEvent);

        // stack appended, now display-lay
        String thread = getThread();
        Stack<String[]> calls = getCallStack(thread);
        StringBuffer msg = new StringBuffer();
        StringBuffer indent = new StringBuffer();
        int indentSize = calls != null ? calls.size() : 0;
        if (isEntering() && indentSize > 0) {
            // hold that one back
            indentSize--;
        }
        for (int i = 0; i < indentSize; i++) {
            indent.append(INDENT);
        }
        
        String indentActual = indent.toString();
        String[] tokens = logEvent.split("\n"); // split on newline, makes this next bit easier
        for (int i = 0; i < tokens.length; i++) {
            String token = tokens[i];
            msg.append(token.replaceAll("^", indentActual));
            if (i < tokens.length - 1) {
                // needs a newish-line
                msg.append("\n");
            }
        }
        //msg.append(logEvent);
        _msgs.add(msg.toString());
    }

    public String compileSummary() {
        StringBuffer summary = new StringBuffer();
        for (String msg : _msgs) {
            summary.append(msg + "\n");
        }
        return summary.toString();
    }

}
