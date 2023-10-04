package sailpoint.rule;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import sailpoint.object.CertificationDefinition;
import sailpoint.object.Duration.Scale;
import sailpoint.object.TaskSchedule;
import sailpoint.tools.CronString;

public class Rule_AccelerateCertDurations extends GenericRule {

	
	String scheduleId = "Manager Certification [DATE] [1/23/12 12:26 PM]";
	boolean launchSchedule = true;
	
	boolean doActiveDuration = true;
	long activeDurationValue = 1;
	String activeDurationScale = "Minute";
	
	boolean doChallengeDuration = true;
	long challengeDurationValue = 1;
	String challengeDurationScale = "Minute";
	
	boolean doRevocationDuration = true;
	long revocationDurationValue = 1;
	String revocationDurationScale = "Minute";
	
	
	
	
	@Override
	public Object execute() throws Throwable {

		// get the schedule
		TaskSchedule schedule = context.getObject(TaskSchedule.class, scheduleId);
		if (schedule == null) {
			String msg = "CertificationDefinition not found!  Aborting.";
			log.warn(msg);
			return msg;
		}
		
		// got a schedule.  Get definition
		Map<String, Object> attr = schedule.getArguments();
		String definitionId = (String)attr.get("certificationDefinitionId");
		if (definitionId == null) {
			String msg = "Definition ID not found!  Aborting.";
			log.warn(msg);
			return msg;
		}
		
		CertificationDefinition definition = context.getObject(CertificationDefinition.class, definitionId);
		if (definition == null) {
			String msg = "CertificationDefinition not found!  Aborting. id=" + definitionId;
			log.warn(msg);
			return msg;
		}
		
		// we have everything we need
		if (doActiveDuration) {
			definition.setActivePeriodDurationAmount(activeDurationValue);
			definition.setActivePeriodDurationScale(Scale.valueOf(activeDurationScale));
		}
		
		if (doChallengeDuration) {
			definition.setChallengePeriodDurationAmount(challengeDurationValue);
			definition.setChallengePeriodDurationScale(Scale.valueOf(challengeDurationScale));
		}
		
		if (doRevocationDuration) {
			definition.setRemediationPeriodDurationAmount(revocationDurationValue);
			definition.setRemediationPeriodDurationScale(Scale.valueOf(revocationDurationScale));
		}
		
		context.saveObject(definition);
		
		if (launchSchedule) {
			// simplest way via a rule to launch it is to set the next execution to now.  Let the scheduler handle the rest
			// hmm, vaguely recall messing with TaskSchedules to be tricky
			Date nextStart = new Date();
			CronString cronString = new CronString(nextStart, CronString.FREQ_ANNUALLY);
			schedule.setNextExecution(new Date());
			List<String> expressions = new ArrayList();
			expressions.add(cronString.toString());
			schedule.setCronExpressions(expressions);
			context.saveObject(schedule);
		}
		
		
		context.commitTransaction();
		return null;
	}
	
	/*
activePeriodDurationAmount
activePeriodDurationScale

challengePeriodDurationAmount
challengePeriodDurationScale

mitigationDurationAmount
mitigationDurationScale


	 */
}
