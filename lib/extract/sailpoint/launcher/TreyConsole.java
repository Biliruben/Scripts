package sailpoint.launcher;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.hibernate.cfg.Configuration;
import org.hibernate.mapping.PersistentClass;
import org.hibernate.mapping.Property;
import org.hibernate.mapping.Value;
import org.hibernate.type.Type;

import sailpoint.api.DatabaseVersionException;
import sailpoint.api.SailPointContext;
import sailpoint.api.SailPointFactory;
import sailpoint.api.Terminator;
import sailpoint.api.Workflower;
import sailpoint.integration.RequestResult;
import sailpoint.object.Attributes;
import sailpoint.object.AuditEvent;
import sailpoint.object.Bundle;
import sailpoint.object.Comment;
import sailpoint.object.EmailTemplate;
import sailpoint.object.Filter;
import sailpoint.object.Filter.MatchMode;
import sailpoint.object.Identity;
import sailpoint.object.IdentityRequest;
import sailpoint.object.IdentityRequest.ExecutionStatus;
import sailpoint.object.IdentityRequestItem;
import sailpoint.object.QueryOptions;
import sailpoint.object.Reference;
import sailpoint.object.Request;
import sailpoint.object.RequestDefinition;
import sailpoint.object.SailPointObject;
import sailpoint.object.Source;
import sailpoint.object.TaskResult;
import sailpoint.object.WorkItem;
import sailpoint.object.Workflow;
import sailpoint.object.WorkflowCase;
import sailpoint.object.WorkflowSummary.ApprovalSummary;
import sailpoint.persistence.SPNamingStrategy;
import sailpoint.request.EmailRequestExecutor;
import sailpoint.server.Auditor;
import sailpoint.server.SailPointConsole;
import sailpoint.spring.SpringStarter;
import sailpoint.tools.GeneralException;
import sailpoint.tools.Message;
import sailpoint.tools.Util;
import sailpoint.tools.xml.XMLObjectFactory;
import biliruben.api.DataTokenBuilder;

public class TreyConsole extends SailPointConsole {

    private static Configuration _config;
    private Set<String[]> _names;
    private PrintWriter _out;
    private int _propNameMaxLength;

    /**
     * Parse and remove args that are relevant to us before passing
     * them on to sailpoint.tools.Console.
     * This is a stupid parser and has awareness of what Console 
     * will do.
     */
    private static String parseSpringOverride(String[] args) {

        String override = null;

        int index = 0; 
        while (override == null && index < args.length) {
            String arg = args[index];
            if (arg.startsWith("-")) {
                // -c and -f both have secondary args
                if (arg.equals("-c") || arg.equals("-f"))
                    index++;
            }
            else {
                // assume the first thing without a prefix
                // is our override file
                override = arg;
            }
            index++;
        }
        return override;
    }

    public static void main(String[] args) {

        // look for a spring file override
        String override = parseSpringOverride(args);

        String dflt = "iiqBeans";
        SpringStarter ss = new SpringStarter(dflt, override);

        String configFile = ss.getConfigFile();
        if (!configFile.startsWith(dflt))
            println("Reading spring config from: " + configFile);

        try {
            // suppress the background schedulers
            ss.setSuppressTaskScheduler(true);
            ss.setSuppressRequestScheduler(true);
            ss.start();

            TreyConsole console = new TreyConsole();
            // Horked from the Hibernate Utils class
            _config = new Configuration();
            _config.setNamingStrategy(new SPNamingStrategy());
            _config.configure("hibernate.cfg.xml");
            console.run(args);
        }
        catch (DatabaseVersionException dve) {
            // format this more better  
            println(dve.getMessage());
        }
        catch (Throwable t) {
            println(t);
        }
        finally {
            ss.close();
        }		
    }

    @Override
    public void addSailPointConsoleCommands() {
        super.addSailPointConsoleCommands();
        addCommand("getAny", "Fetches XML for any object", "cmdGetAny");
        addCommand("property", "Displays property information of a given class.", "cmdProperty");
        addCommand("mappedClasses", "Displays classes mapped in the Hibernate configuration.", "cmdMappedClasses");
        addCommand("password", "Changes the password for an Identity", "cmdPassword");
        addCommand("npe", "Dumb command that might throw an NPE", "cmdNpe");
        addCommand("deleteAny", "Deletes any object", "cmdDeleteAny");
        addCommand("generateObjects", "Generates random objects", "cmdGenerateObjects");
        addCommand("cancelIdentityRequest", "Cancels one or all IdentityRequests", "cmdCancelRequests");
        addCommand("generateArgsFile", "Generates an Args file that can be used with rules / workflows", "cmdGenerateArgsFile");
    }

    /*
     * Fetches the name and value type of the given property.  Tracks the longest string
     * length of all known property names to ensure prety formatting
     */
    private void addProperty (Property prop) {
        Value v = prop.getValue();
        Type type = v.getType();
        _propNameMaxLength = prop.getName().length() > _propNameMaxLength ? prop.getName().length() : _propNameMaxLength;
        _names.add(new String[] {prop.getName(), type.getName()});
    }

    /*
     * Loads the provided class's mappings and iterates the properties
     */
    private void exploreProperties(String name) {
        PersistentClass pc = _config.getClassMapping(name);
        if (pc == null) {
            _out.println("Could not load mappings for " + name);
        } else {
            Iterator propertyIt = pc.getDeclaredPropertyIterator(); // Hibernate doesn't parameterize this iterator
            _names = new HashSet<String[]>();
            Set<String> sortedNames = new TreeSet<String>();
            while (propertyIt.hasNext()) {
                addProperty((Property) propertyIt.next()); // They's all properties, so cast away
            }
            addProperty(pc.getIdentifierProperty()); // Don't forget the identifier property (aka 'id')
            // Second pass thru is for formatting and sorting
            for (String[] propNameArry : _names) {
                String propName = propNameArry[0];
                propName = String.format("%1$-" + _propNameMaxLength + "s", propName);
                String typeName = propNameArry[1];
                sortedNames.add(propName + " : " + typeName);
            }
            // Third pass goes out
            for (String sortedName : sortedNames) {
                _out.println(sortedName);
            }
        }
    }

    /**
     * Property Command: list the provided class's properties
     * @param args
     * @param out
     * @throws Exception
     */
    public void cmdProperty(List<String> args, PrintWriter out) throws Exception {
        int nargs = args.size();
        _out = out;
        _propNameMaxLength = 1;
        if (nargs != 1) { // balk when no or multiple options passed
            out.format("property <Any Mapped Class>\n");
        }
        else {
            String name = args.get(0);
            if (!name.matches("^.*\\..*")) {  // did they give it a proper path?
                name = "sailpoint.object." + name; // No?  Assume sailpoint.obj
            }
            exploreProperties(name);
        }
    }

    private String promptForValidChoice(Scanner scanner, String prompt, String[] choices) {
        boolean found = false;
        String choice = null;
        do {
            System.out.print(prompt + ": ");
            System.out.println(Arrays.toString(choices));
            choice = scanner.nextLine();
            for (String c : choices) {
                if (c.equalsIgnoreCase(choice)) {
                    choice = c; // in case case matters to the caller
                    found = true;
                    break;
                }
            }
        } while (!found);
        return choice;
    }

    private Object promptForPrimative(Scanner input) {
        Object value = null;
        do {
            String prompt = "Type of primative (0 = String, 1 = Integer, 2 = Double): ";
            String[] choices = {"0", "1", "2"};
            String primType = promptForValidChoice(input, prompt, choices);
            int choice = Integer.valueOf(primType);
            prompt = "Value for type ";
            String rawValue = null;

            switch (choice) {
            case 0:
                prompt += "String: ";
                System.out.print(prompt);
                value = input.nextLine();
                break;
            case 1:
                prompt += "Integer: ";
                System.out.print(prompt);
                rawValue = input.nextLine();  // sure, you could use input.nextLong().  But that's boring
                try {
                    value = Integer.valueOf(rawValue);
                } catch (Exception e) {
                    System.out.println("Illegal integer: " + rawValue);
                }
                break;
            case 2:
                prompt += "Double: ";
                System.out.print(prompt);
                rawValue = input.nextLine();
                try {
                    value = Double.valueOf(rawValue);
                } catch (Exception e) {
                    System.out.println("Illegal double: " + rawValue);
                }
                break;
            }
        } while (value == null);
        return value;
    }

    private Reference promptForReference(Scanner input, SailPointContext ctx) {
        Map<String, String> map = promptForSPObject(input, ctx);
        Reference r = null;
        if (map != null) {
            r = new Reference(map.get("class"), map.get("id"), map.get("name"));
        }
        return r;
    }

    private Map<String, String> promptForSPObject(Scanner input, SailPointContext ctx) {
        Map<String, String> map = new HashMap<String, String>();
        boolean found = false;
        do {
            System.out.println("Class name (simple, ex. Identity, Application): ");
            String className = "sailpoint.object." + input.nextLine();
            String originalPrompt = "Type the name or partial name (begins with) of the desired object: ";
            String prompt = originalPrompt;
            try {
                Class clazz = Class.forName(className);
                String name = "";
                do {
                    System.out.print(prompt);
                    Map<String, String> lineMap = new HashMap<String, String>();
                    String partial = input.nextLine().trim();
                    if ("".equals(partial.trim())) {
                        System.out.println("Returning to last menu.");
                        found = true;
                    } else {
                        name += partial;
                        QueryOptions options = new QueryOptions();
                        options.add(Filter.like("name", name, MatchMode.START));
                        Iterator<Object[]> results = ctx.search(clazz, options, "id,name");
                        while (results.hasNext()) {
                            Object[] line = results.next();
                            lineMap.put((String)line[0], (String)line[1]);
                        }
                        if (lineMap.size() > 1) {
                            StringBuilder names = new StringBuilder();
                            for (String foundName : lineMap.values()) {
                                names.append(foundName + "\n");
                            }
                            System.out.println("Please narrow your choice, I've found: \n");
                            System.out.println(names.toString());
                            name = "";
                        } else if (lineMap.size() == 0) {
                            System.out.println("No results found for " + partial + ", please try again.");
                            prompt = originalPrompt;
                            name = "";
                        } else {
                            // one result found!
                            map.put("id", lineMap.keySet().iterator().next());
                            map.put("name", lineMap.values().iterator().next());
                            map.put("class", clazz.getName());
                            found = true;
                        }
                    }
                } while (!found);
            } catch (Throwable e) {
                System.out.println("Illegal choice (Did you use the right case?): " + e.getMessage());
            }
        } while (!found);
        return map;
    }

    private SailPointObject promptForLiteral(Scanner input, SailPointContext ctx) throws GeneralException, ClassNotFoundException {
        Map<String, String> map = promptForSPObject(input, ctx);
        String id = map.get("id");
        String className = map.get("class");
        Class clazz = Class.forName(className);
        SailPointObject o = ctx.getObjectById(clazz, id);
        if (o instanceof Identity) {
            // The Role Metadata can be annoying.. just ditch it
            Identity i = (Identity)o;
            i.setRoleMetadatas(null);
            XMLObjectFactory f = XMLObjectFactory.getInstance();
            o = (SailPointObject) f.parseXml(ctx, i.toXml(), false); // poor man's clone
        }
        return o;
    }
    /**
     * Given a filename, steps the user through creating an Attributes map that can be later
     * used for a rule or workflow args file
     * @param args
     * @param out
     * @throws Exception
     */
    public void cmdGenerateArgsFile(List<String> args, PrintWriter out) throws Exception {
        SailPointContext ctx = createContext();
        boolean showUsage = false;
        boolean noClean = false;
        try {
            String fileName = null;
            if (args != null && args.size() > 0) {
                fileName = args.get(0);
                if (fileName.equals("?")) {
                    showUsage = true;
                } else if (fileName.equals("-noClean")) {
                    fileName = null; // probably not the best design, but it works
                    noClean = true;
                }
                if (args.size() > 1) {
                    if (args.get(1).equalsIgnoreCase("-noClean")) {
                        noClean = true;
                    } else {
                        showUsage = true;
                    }
                }
                if (showUsage) {
                    System.out.println("generateArgs [fileName] [-noClean]");
                    return;
                }
            } else {
                System.out.println("No file name provide, will output result to console.");
            }
            Scanner input = new Scanner(System.in);
            boolean done = false;
            boolean secondaryPrompt = false;
            Attributes attr = new Attributes();
            String argName = null;
            do {
                String prompt = "Name of argument ('Q' to quit): ";
                if (!secondaryPrompt) {
                    System.out.print(prompt);
                    argName = input.nextLine().trim();
                }
                if ("q".equalsIgnoreCase(argName) || "".equals(argName)) {
                    done = true;
                } else {
                    prompt = "Type of object " + argName + " is: (0 = String / Primative, 1 = Reference, 2 = Object Literal";
                    String[] choices = null;
                    if (!secondaryPrompt) {
                        prompt +=", 3 = Array)";
                        choices = new String[]{"0", "1", "2", "3"};
                    } else {
                        prompt +=")";
                        choices = new String[]{"0", "1", "2"};
                    }
                    String type = promptForValidChoice(input, prompt, choices);
                    Object value = null;
                    int choice = Integer.valueOf(type);
                    if (!secondaryPrompt) {
                        switch (choice) {
                        case 0: value = promptForPrimative(input); break;
                        case 1: value = promptForReference(input, ctx); break;
                        case 2: value = promptForLiteral(input, ctx); break;
                        case 3: secondaryPrompt = true;
                            System.out.println("Generating an array of values...");
                            break;
                        default: System.out.println("Illegal choice!"); break;
                        }
                    } else {
                        boolean finishedList = false;
                        List values = new ArrayList();
                        do {
                            switch (choice) {
                            case 0: value = promptForPrimative(input); break;
                            case 1: value = promptForReference(input, ctx); break;
                            case 2: value = promptForLiteral(input, ctx); break;
                            case 3: secondaryPrompt = true; break;
                            default: System.out.println("Illegal choice!"); break;
                            }
                            values.add(value);
                            prompt = "Next element? [y/n]";
                            String[] ynChoices = {"y", "n"};
                            String ynPrompt = promptForValidChoice(input, prompt, ynChoices);
                            if ("n".equalsIgnoreCase(ynPrompt)) {
                                finishedList = true;
                            }
                        } while (!finishedList);
                        value = values;
                        secondaryPrompt = false;
                    }
                    attr.put(argName, value);
                }
                if (!secondaryPrompt) {
                    System.out.println("Current attributes: " + attr);
                }
            } while (!done);
            XMLObjectFactory f = XMLObjectFactory.getInstance();
            String xml = f.toXml(attr, true);
            if (!noClean) {
                xml = cleanXml(xml);
            }
            if (fileName == null || "".equals(fileName.trim())) {
                System.out.println(xml);
            } else {
                File file = new File(fileName);
                FileWriter writer = new FileWriter(file);
                writer.write(xml);
                writer.flush();
                writer.close();
                System.out.println("Wrote file: " + fileName);
            }

        } finally {
            SailPointFactory.releaseContext(ctx);
        }
    }

    /*
     * A very simple cleaner that strips 'id=' attributes off of the incoming XML.  By very simple, I mean:
     * - it doesn't care what id it finds, it'll prune it
     * - it doesn't care if you didn't give it XML in the first place
     * - it doesn't care if what it gives back to you isn't XML either
     * - the Pattern used is as strict match of '\sid=\S*' and replaces it with a single space
     */
    private String cleanXml(String xml) {
        Pattern idPattern = Pattern.compile("\\sid=\\S*", Pattern.DOTALL);
        Matcher m = idPattern.matcher(xml);
        String cleanedXml = m.replaceAll(" ");
        return cleanedXml;
    }

    /**
     * Deletes any arbitrary object
     */
    public void cmdDeleteAny(List<String> args, PrintWriter out) throws Exception {
        int nargs = args.size();
        _out = out;
        if (nargs != 2) {
            out.format("deleteAny <Class> <name or id>\n");
        }
        else {
            Class cls = null;
            String clsname = args.get(0);
            if ( isWorkgroupSubtype(clsname) ) {
                cls = Identity.class;
            } else {
                cls = Class.forName("sailpoint.object." + clsname);
            }
            String name = args.get(1);
            if (cls != null) {
                SailPointContext ctx = createContext();
                try
                {
                    SailPointObject obj = findObject(ctx, cls, clsname, name, out);
                    if (obj != null) {
                        Terminator t = new Terminator(ctx);
                        t.deleteObject(obj);
                        ctx.commitTransaction();
                    }


                    // temporary, testing Hibernate cache issues
                    //ctx.commitTransaction();
                }
                finally
                {
                    SailPointFactory.releaseContext(ctx);
                }
            }
        }
    }

    private boolean objectExists(SailPointContext ctx, Class<? extends SailPointObject> clazz, String name) throws GeneralException {
        Filter f = Filter.eq("name", name);
        QueryOptions opts = new QueryOptions(f);
        int count = ctx.countObjects(clazz, opts);
        return count > 0;
    }

    public void cmdGenerateObjects(List<String> args, PrintWriter out) throws Exception {
        // TODO: add help, validity check

        String objectType = args.get(0);
        SailPointContext ctx = createContext();
        try {
            int total = Integer.valueOf(args.get(1));
            String dataDirectory = "data";
            if ("bundle".equalsIgnoreCase(objectType)) {
                DataTokenBuilder builder = new DataTokenBuilder(new File(dataDirectory), "[Place] // [Street] [Job]", false);
                DataTokenBuilder descriptionBuilder = new DataTokenBuilder(new File(dataDirectory), "[Title] [FirstName] [LastName]", false);
                Iterator<String> it = builder.iterator();
                Iterator<String> descIt = descriptionBuilder.iterator();
                while (total > 0 && it.hasNext() && descIt.hasNext()) {
                    String name = it.next();
                    if (!objectExists(ctx, Bundle.class, name)) {
                        String desc = descIt.next();
                        out.format("%s\n", "Creating bundle: " + name);
                        createBundle(ctx, name, desc);
                        total--;
                    }
                }
            } else if ("request".equalsIgnoreCase(objectType)) {
                String type = null;
                if (args.size() > 2) {
                    type = args.get(2);
                }
                if (type == null || "email".equalsIgnoreCase(type)) {
                    QueryOptions opts = new QueryOptions();
                    opts.setResultLimit(1);
                    List<EmailTemplate> templates = ctx.getObjects(EmailTemplate.class, opts);
                    EmailTemplate template = null;
                    if (templates != null && templates.size() > 0) {
                        template = templates.get(0);
                    }
                    DataTokenBuilder builder = new DataTokenBuilder(new File(dataDirectory), "Request for [Title] [FirstName] [LastName]", false);
                    Iterator<String> it = builder.iterator();
                    while (total > 0 && it.hasNext()) {
                        total--;
                        if (total % 100 == 0) {
                            out.format("%s\n", total + " remaining...");
                        }
                        String name = it.next();
                        createEmailRequest(ctx, name, template);
                    }
                } else if ("workflow".equalsIgnoreCase(type)) {
                    while (total > 0) {
                        total--;
                        if (total % 100 == 0) {
                            out.format("%s\n", total + " remaining...");
                        }
                        createWFRequest(ctx, "Basic Workflow Request");
                    }
                }
            }
        } finally {
            SailPointFactory.releaseContext(ctx);
        }
    }

    private void createWFRequest(SailPointContext ctx, String name) throws GeneralException {
        RequestDefinition def = ctx.getObjectByName(RequestDefinition.class, "Workflow Request");
        Request wfRequest = new Request(def);
        wfRequest.setName(name);
        wfRequest.setDescription("workflow for " + name);
        wfRequest.setAttribute("workflow", "Basic Workflow");
        ctx.saveObject(wfRequest);
        ctx.commitTransaction();
    }

    private void createEmailRequest(SailPointContext ctx, String name, EmailTemplate template) throws GeneralException {
        RequestDefinition def = ctx.getObjectByName(RequestDefinition.class, "Email Request");
        Request emailRequest = new Request(def);
        emailRequest.setName(name);
        emailRequest.setDescription(name);
        emailRequest.setAttribute(EmailRequestExecutor.TEMPLATE, template);
        ctx.saveObject(emailRequest);
        ctx.commitTransaction();
    }

    private void createBundle(SailPointContext ctx, String name, String desc) throws GeneralException {
        Bundle newBundle = new Bundle();
        newBundle.setName(name);
        newBundle.setType("business");
        newBundle.setDescription(desc);
        Identity owner = ctx.getObject(Identity.class, "spadmin");
        newBundle.setOwner(owner);
        ctx.saveObject(newBundle);
        ctx.commitTransaction();
    }

    public void cmdNpe(List<String> args, PrintWriter out) throws Exception {
        // needs a single argument: the id of an Identity
        String id = args.get(0);
        SailPointContext ctx = createContext();
        try
        {
            SailPointObject obj = findObject(ctx, Identity.class, "Identity", id, out);
            out.format("%s\n", obj.toXml());

            // temporary, testing Hibernate cache issues
            //ctx.commitTransaction();
        }
        finally
        {
            SailPointFactory.releaseContext(ctx);
        }

    }

    public void cmdPassword(List<String> args, PrintWriter out) throws Exception {
        int nargs = args.size();

        if (nargs != 2) {
            out.format("password identity newPassword");
        } else {
            SailPointContext ctx = createContext();
            try {

                Identity id = ctx.getObjectByName(Identity.class, args.get(0));
                id.setPassword(args.get(1));
                ctx.saveObject(id);
                ctx.commitTransaction();
            }
            finally
            {
                SailPointFactory.releaseContext(ctx);
            }

        }
    }

    private boolean isWorkgroupSubtype(String type ) {
        if ( ( Util.getString(type) != null ) && 
                ( type.toLowerCase().startsWith("workg") ) ) {
            return true;
        }
        return false;
    }

    public void cmdGetAny(List<String> args, PrintWriter out) throws Exception {
        int nargs = args.size();
        _out = out;
        if (nargs != 2) {
            out.format("getAny <Class> <name or id>\n");
        }
        else {
            Class cls = null;
            String clsname = args.get(0);
            if ( isWorkgroupSubtype(clsname) ) {
                cls = Identity.class;
            } else {
                cls = Class.forName("sailpoint.object." + clsname);
            }
            String name = args.get(1);
            if (cls != null) {
                SailPointContext ctx = createContext();
                try
                {
                    SailPointObject obj = findObject(ctx, cls, clsname, name, out);
                    if (obj != null)
                        out.format("%s\n", obj.toXml());

                    // temporary, testing Hibernate cache issues
                    //ctx.commitTransaction();
                }
                finally
                {
                    SailPointFactory.releaseContext(ctx);
                }
            }
        }

    }

    /**
     * Since we don't support authentication yet, pass a pseudo-user
     * name to be used as an audit source.
     */
    private SailPointContext createContext() throws GeneralException {

        return SailPointFactory.createContext("Console");
    }


    /**
     * Mapped Classes command: List the classes defined in the Hibernate mapping configuration
     * @param args
     * @param out
     * @throws Exception
     */
    public void cmdMappedClasses(List<String> args, PrintWriter out) throws Exception {
        Iterator classesIt = _config.getClassMappings();
        Set<String> classes = new TreeSet<String>();
        while (classesIt != null && classesIt.hasNext()) {
            PersistentClass pc = (PersistentClass) classesIt.next();
            classes.add(pc.getClassName()); // for auto-sorting
        }
        for (String clazz : classes) {
            out.println(clazz);
        }
    }

    /**
     * Cancels one or all identity requests
     * @param args
     * @param out
     * @throws Exception
     */
    public void cmdCancelRequests(List<String> args, PrintWriter out) throws Exception {
        SailPointContext ctx = createContext();
        try {
            if (args != null && args.size() > 0) {
                String id = args.get(0);
                out.println("Cancelling request: " + id);
                cancelWorkflow(ctx, id, "Via the console!");
            } else {  // anything Executing must go!
                QueryOptions opts = new QueryOptions();
                opts.add(Filter.eq("executionStatus", IdentityRequest.ExecutionStatus.Executing));
                Iterator<Object[]> rows = ctx.search(IdentityRequest.class, opts, "id");
                List<String> ids = new ArrayList<String>();
                while (rows.hasNext()) {
                    Object[] row = rows.next();
                    String id = (String)row[0];
                    ids.add(id);
                }

                for (String id : ids) {
                    out.println("Cancelling request: " + id);
                    cancelWorkflow(ctx, id, "Via the console!");
                    ctx.decache(); // clean as we go
                }
            }

        } finally {
            SailPointFactory.releaseContext(ctx);
        }
    }

    private void cancelWorkflow(SailPointContext context, String requestId, String comments) throws GeneralException {

        RequestResult result = new RequestResult();


        String taskResult = "";
        IdentityRequest request = null;
        if (requestId != null) {

            request = context.getObject(IdentityRequest.class, requestId);

            if (request == null) {
                result.setStatus(RequestResult.STATUS_FAILURE);
                // this is a edge case so not using a msg here
                result.addError("The identity request was not found.");
            } 
            else {
                taskResult = request.getTaskResultId();
            }
        }

        if (requestId == null || taskResult == null) {
            result.setStatus(RequestResult.STATUS_FAILURE);
            // this is a edge case so not using a msg here
            result.addError("The identity request was not found.");
        }

        TaskResult task = context.getObject(TaskResult.class, taskResult);
        boolean terminated = false;
        if (task != null && task.getCompleted() == null) {

            String caseId = (String) task.getAttribute(WorkflowCase.RES_WORKFLOW_CASE);
            if (caseId != null) {
                WorkflowCase wfCase = context.getObjectById(WorkflowCase.class, caseId);
                Workflower workflower = new Workflower(context);
                workflower.terminate(wfCase);

                terminated = true;
                task.setTerminated(true);
                task.setCompleted(new Date());
                task.setCompletionStatus(task.calculateCompletionStatus());
                context.saveObject(task);  

                // the workflower terminate() method causes lazy init problems
                // on the identity request if we don't refresh the request here.
                // However, the workflower needs to run first so that it can 
                // finish its job of creating an approval summary.  Ah, Hibernate...
                request = context.getObject(IdentityRequest.class, requestId);
                request.setExecutionStatus(ExecutionStatus.Terminated);

                Comment comment = null;
                if ((comments != null) && (!comments.equals(""))) {
                    comment = new Comment();
                    comment.setComment(comments);
                    comment.setDate(new Date());
                    comment.setAuthor(Identity.ADMIN_NAME);
                    request.addMessage(new Message(Message.Type.Error, comment.toString()));

                    if (request.getApprovalSummaries() != null) {
                        for (ApprovalSummary summary : request.getApprovalSummaries()) {
                            summary.addComment(comment);
                        }
                    }
                }

                List<IdentityRequestItem> items = request.getItems();
                if ( items != null ) {
                    for ( IdentityRequestItem item : items) {
                        if ( item != null ) {
                            WorkItem.State state = item.getApprovalState();
                            if ( state == null ) {
                                item.setApprovalState(WorkItem.State.Canceled);
                            }
                        }
                    }
                }

                context.saveObject(request);
                context.commitTransaction();

                AuditEvent event = new AuditEvent();
                event.setSource(Identity.ADMIN_NAME);
                event.setTarget(task.getTargetName());
                event.setTrackingId(wfCase.getWorkflow().getProcessLogId());
                event.setAction(AuditEvent.CancelWorkflow);
                // djs: for now set this in both places to avoid needing
                // to upgrade.  Once we have ui support for "interface"
                // we can remove the map version
                event.setAttribute("interface", Source.LCM.toString());
                event.setInterface(Source.LCM.toString());
                event.setAttribute(Workflow.VAR_TASK_RESULT, taskResult);
                if (comment != null) {
                    // Storing as a list so we're consistent with other audit event types.
                    event.setAttribute("completionComments", Arrays.asList(comment));
                }
                Auditor.log(event);
                context.commitTransaction();

                result.setStatus(RequestResult.STATUS_SUCCESS);
            }
        } else if (task != null && task.getCompleted() != null) {
            // Somehow the task was completed before we got there.
            // Consider the request done and move on.
            terminated = true;
            result.setStatus(RequestResult.STATUS_SUCCESS);
        }

        if (!terminated) {
            result.setStatus(RequestResult.STATUS_FAILURE);
            // this is a edge case so not using a msg here
            result.addError("The workflow assigned to task result '" + taskResult + "' was not found.");
        }

    }

}
