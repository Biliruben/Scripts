package sailpoint.custom.task;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import sailpoint.api.SailPointContext;
import sailpoint.api.SailPointFactory;
import sailpoint.api.TaskManager;
import sailpoint.object.Attributes;
import sailpoint.object.Filter;
import sailpoint.object.QueryOptions;
import sailpoint.object.TaskDefinition;
import sailpoint.object.TaskResult;
import sailpoint.object.TaskSchedule;
import sailpoint.task.AbstractTaskExecutor;
import sailpoint.task.TaskMonitor;
import sailpoint.tools.GeneralException;
import sailpoint.tools.Message;
import sailpoint.tools.Util;
import sailpoint.web.messages.MessageKeys;

public class TerminatingTaskWrapperExecutor extends AbstractTaskExecutor {

    public static final String ARG_TASK_LIST = "taskList";
    public static final String ARG_TERMINATE_MS = "timeToTerminate";
    public static final int DEFAULT_TERMINATE_MS = 5000;
    private boolean terminate;
    
    boolean trace;
    
    boolean exitOnError;
    
    TaskMonitor monitor;
    private int _timeToTerminate;

    private static Log log = LogFactory.getLog(TerminatingTaskWrapperExecutor.class);
    
    public void execute(SailPointContext ctx, TaskSchedule sched,
            TaskResult result, Attributes<String, Object> args)
            throws Exception {
        
        // create a TaskManager for managing tasks
        TaskManager tm = new TaskManager(ctx);
        if(result.getOwner()!=null)
            tm.setLauncher(result.getOwner().getName());

        // Monitor should use it's own context
        monitor = new TaskMonitor(ctx, result);
        trace = args.getBoolean(ARG_TRACE);

        String taskString = args.getString("taskList");
        List<String> theList = Util.csvToList(taskString);
        String runResults =new String();
        
        _timeToTerminate = args.getInt(ARG_TERMINATE_MS, DEFAULT_TERMINATE_MS);

        for (String taskId : theList) {
            if(this.terminate)
                break;
            // build the launch arguments
            // you may not have any of these depending on the task
            Attributes<String, Object> moreArgs = new Attributes<String, Object>();

            TaskDefinition task = ctx.getObject(TaskDefinition.class, taskId);
            if (task == null) {
                // misconfigured task list, assuming that it's okay
                // to die since the other tasks in the list
                // may be dependent on the missing one
                throw new GeneralException("Missing Task Definition: " + taskId);
            }

            String taskName = task.getName();
            
            trace(taskName + ": Running");
            monitor.updateProgress(taskName + ": Running");
            
            runResults = runResults.concat(taskName + ": Starting");
            result.setAttribute("tasksRun", runResults);
            
            /** Run the child in the background and sleep for five seconds to let the scheduler
             * pick it up**/
            TerminatorThread terminator = new TerminatorThread(tm, _timeToTerminate, task.getName());
            Thread t = new Thread(terminator);
            t.start();
            TaskResult res = tm.runSync(task, moreArgs);
            terminator.setRunning(false);
            //TaskResult res = tm.runWithResult(task, moreArgs);
            
            /** If the child task had an error, bail out on this one **/
            if( hasError( ctx, res.getName() ) ) {
                trace(taskName + ": Encountered an Error.");
                runResults = runResults.concat("\n" + taskName + ": Error.\n");
                monitor.updateProgress(taskName + ": Encountered an Error.");
                
                if(exitOnError) {
                    runResults = runResults.concat("\n" + taskName + ": Error.  Exiting.\n");
                    result.setAttribute("tasksRun", runResults);                
                    result.addMessage(new Message(Message.Type.Error, MessageKeys.TASK_SEQUENTIAL_ERROR_ENCOUNTERED, taskName));
                
                    ctx.saveObject(result);
                    ctx.commitTransaction();
                    return;
                }
            }else {           
                trace(taskName + ": Complete");
                runResults = runResults.concat("\n" + taskName + ": Complete" + "\n\n");
            }
            result.setAttribute("tasksRun", runResults);
        }
        
        trace("Sequential Task complete.");
        result.setAttribute("tasksRun", runResults);
        ctx.saveObject(result);
        ctx.commitTransaction();
        return;


    }

    public boolean terminate() {
        // TODO Auto-generated method stub
        return false;
    }

    private void trace(String msg) {
        log.info(msg);
        if (trace)
            System.out.println(msg);
    }
    
    /** Determines if the task that just completed had an error or not **/
    private boolean hasError(SailPointContext ctx, String resultName) throws GeneralException{
        List<String> props = Arrays.asList("messages");
        QueryOptions qo = new QueryOptions();
        qo.add(Filter.eq("name", resultName));
        Iterator<Object[]> rows = ctx.search(TaskResult.class, qo, props);
        if(rows.hasNext()) {
            Object[] obj = rows.next();
            List<Message> messages = (List<Message>)obj[0];
            if(messages!=null) {
                for(Message msg : messages) {
                    if(msg.getType().equals(Message.Type.Error)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    private static class TerminatorThread implements Runnable {

        private TaskManager _mgr;
        private int _ttt;
        private String _taskName;
        private boolean _isRunning;
        
        TerminatorThread(TaskManager taskManager, int timeToTerminate, String taskName) {
            _mgr = taskManager;
            _ttt = timeToTerminate;
            _taskName = taskName;
        }
        
        public void run() {
            _isRunning = true;
            try {
                Thread.sleep(_ttt);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            if (_isRunning) {
                _mgr.terminate();
            }
        }
        
        public void setRunning(boolean isRunning) {
            _isRunning = isRunning;
        }
    }
}
