package sailpoint;

import sailpoint.api.SailPointContext;
import sailpoint.object.Attributes;
import sailpoint.request.RequestProcessor;
import sailpoint.rule.Rule_RunPreparedStatement;
import sailpoint.services.task.TaskExecutorWrapper;

public class MyTester {

	/**
	 * @param args
	 * @throws InterruptedException 
	 */
	public static void main(String[] args) throws InterruptedException {
		// TODO Auto-generated method stub
		
		Class taskExecutor = Rule_RunPreparedStatement.class;
		
		Attributes<String, Object> attr = new Attributes();
		//attr.put(IDXSQLAnalyzerExecutor.ARG_READ_ONLY, true);
		attr.put("taskList", "Refresh Identity Cube,Aggregate HR Authoritative");
		
		TaskExecutorWrapper wrapper = new TaskExecutorWrapper();
		SailPointContext context = wrapper.initialize();
		wrapper.execute(context, taskExecutor, attr);
		// instead of executing a task, I want to launch a thread
		//RequestProcessor proc = RequestProcessor.getInstance(); // auto starts our instance
		/*
		while (proc.isAlive()) {
		    Thread.sleep(10000);
		}
		*/
	}

}
