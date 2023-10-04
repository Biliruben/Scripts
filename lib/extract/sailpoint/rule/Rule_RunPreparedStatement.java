package sailpoint.rule;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.apache.commons.logging.LogFactory;
import sailpoint.tools.GeneralException;

public class Rule_RunPreparedStatement extends GenericRule {

    /*
     * Parameters array is defined as:
     * An array of arrays where each element array has two elements.  The first being one of, 
     * "string", "int", "boolean", "double", "long".  Any value provided that doesn't match
     * will cause a GeneralException.  The second element will be the intended value.
     *    
     * An example array may be: {{"string", "foo"}, {"boolean", "true"}, {"int", "2"}}.  Note that
     * all values are strings even when their declared type may be otherwise.
     * 
     * Note: this rule makes no attempt to translate a boolean type into an integer type, as is required
     * on some platforms such as Oracle.  The caller is expected to provide the proper raw types as expected
     * by the target platform.
     */
    /* Input parameters */
    List parameters = null;
    String sql = null;
    
    /* Rule vargs */
    PreparedStatement rawSqlStatement = null;
    PreparedStatement parameterizedStatement = null;

    String buildSql() throws GeneralException, SQLException {
        String rawSql = sql;

        int i = 1;
        for (Object parameterObj : parameters) {
            List parameterList = (List)parameterObj;
            String type = ((String)parameterList.get(0)).trim();
            String valueString = (String)parameterList.get(1);
            if ("string".equalsIgnoreCase(type)) {
                parameterizedStatement.setString(i, valueString);
                rawSql = rawSql.replaceFirst("\\?", "\'" + valueString + "\'");
            } else if ("int".equalsIgnoreCase(type)) {
                int valueInt = Integer.valueOf(valueString);
                parameterizedStatement.setInt(i, valueInt);
                rawSql = rawSql.replaceFirst("\\?", valueString);
            } else if ("boolean".equals(type)) {
                boolean valueBool = Boolean.valueOf(valueString);
                parameterizedStatement.setBoolean(i, valueBool);
                rawSql = rawSql.replaceFirst("\\?", valueString);
            } else if ("double".equals(type)) {
                double valueDouble = Double.valueOf(valueString);
                parameterizedStatement.setDouble(i, valueDouble);
                rawSql = rawSql.replaceFirst("\\?", valueString);
            } else if ("long".equals(type)) {
                long valueLong = Long.valueOf(valueString);
                parameterizedStatement.setLong(i, valueLong);
                rawSql = rawSql.replaceFirst("\\?", valueString);
            } else {
                throw new GeneralException("Type \'" + type + "\' is not a valid parameter type for this rule.");
            }
            i++;
        }
        
        log.debug("Built SQL: " + rawSql);
        
        return rawSql;
    }
    
    /*
     * Returns the row count and logs the details of the query
     */
    int executeStatement(PreparedStatement statement) throws SQLException {
        ResultSet results = statement.executeQuery();
        int rows = 0;
        while (results.next()) {
            rows++;
            if (log.isDebugEnabled()) {
                StringBuilder builder = new StringBuilder();
                int columns = statement.getMetaData().getColumnCount();
                builder.append("{");
                for (int i = 1; i <= columns; i++) { // columns are a 1-based list, as opposed to the usual 0-based
                    builder.append(results.getString(i));
                    if (i < columns) {
                        builder.append(", ");
                    }
                }
                builder.append("}\n");
                log.debug(builder.toString());
                builder = new StringBuilder();
            }
        }
        return rows;
    }
    
    @Override
    public Object execute() throws Throwable {

        
        // new design: user provides a rule with parameters and a parameter map
        
        // we build two statements: one with an SQL query and another with a parameterized prepared statement.
        // Run both statements and log the results
        
        // This is to be run as a rule, so the 'user' would like input paramters by specifying them in the rule.
        // However, it should be flexible enough to pull them out of passed parameters also
        
        // One execution of the rule represents a test of one query and thus two total queries to the database.  Running
        // multiple tests will require multiple executions to the rule.  Programmatic execution can be extended
        // by calling this rule as a sub-rule for another.
        
        log = LogFactory.getLog("sailpoint.rule.RunPreparedStatement");
        
        String LOCAL_SQL = "select distinct count(distinct spt_identity.id) from spt_identity where (spt_identity.workgroup in (?,?)) and (upper(spt_identity.firstname) like ? or upper(spt_identity.lastname) like ? or upper(spt_identity.name) like ?)";;
        List LOCAL_PAREMETERS = new ArrayList();
        LOCAL_PAREMETERS.add(Arrays.asList(new String[]{"int", "0"}));
        LOCAL_PAREMETERS.add(Arrays.asList(new String[]{"int", "1"}));
        LOCAL_PAREMETERS.add(Arrays.asList(new String[]{"string", "SPADMIN%"}));
        LOCAL_PAREMETERS.add(Arrays.asList(new String[]{"string", "SPADMIN%"}));
        LOCAL_PAREMETERS.add(Arrays.asList(new String[]{"string", "SPADMIN%"}));
        
        // flow:
        // get arguments
        if (parameters == null || parameters.size() == 0) {
            if (LOCAL_PAREMETERS == null || LOCAL_PAREMETERS.size() == 0) {
                log.warn("No parameters were passed in or already provided");
            } else {
                log.debug("Using local parameters");
                parameters = LOCAL_PAREMETERS;
            }
        }
        
        // get sql
        if (sql == null || "".equals(sql.trim())) {
            if (LOCAL_SQL == null || "".equals(LOCAL_SQL.trim())) {
                throw new GeneralException("No SQL provided!");
            }
            log.debug("Using local sql");
            sql = LOCAL_SQL;
        }
        
        log.debug("Using sql: " + sql);
        log.debug("Using parameters: " + parameters);
        
        // build SQL and parameterized statement, store in global
        Connection con = context.getConnection();
        parameterizedStatement = con.prepareStatement(sql); // we want this defined now so we can build it as we parse parameters
        String completeSql = buildSql();
        rawSqlStatement = con.prepareStatement(completeSql); // curious, do we need to execute the first prepared statement before creating a second?
        
        StringBuilder resultStringBuilder = new StringBuilder();
        // execute both statements and log results; Return summary of row counts.
        int rows = executeStatement(parameterizedStatement);
        resultStringBuilder.append("Parameterized statement returned ").append(rows).append(" rows\n");
        
        rows = executeStatement(rawSqlStatement);
        resultStringBuilder.append("Raw statement returned ").append(rows).append(" rows");
        
        return resultStringBuilder.toString();
        
    }

}
