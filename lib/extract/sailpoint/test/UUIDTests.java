package sailpoint.test;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;

import com.mysql.jdbc.Driver;

import sailpoint.id.UUIDHexGenerator;

public class UUIDTests {


    public static void main(String[] args) throws SQLException, InterruptedException {
        UUIDHexGenerator genny = new UUIDHexGenerator();
        String whoami = args[0];
        String url = "jdbc:mysql://localhost/hr_data";
        Driver driver = new Driver();
        DriverManager.registerDriver(driver);
        Connection conn = DriverManager.getConnection(url, "root", "root");
        Statement st = conn.createStatement();
        Serializable nextId = genny.generate();
        System.out.println("First id: " + nextId); // visual analysis will help us to determine if we should let it run
        
        String[] newArgs = {"" + nextId};
        UUIDLayout.main(newArgs);
        Random rando = new Random();
        // each jvm gets a waiting period that will be different (hopefully)
        // than from each other.  This will help allow counters to overlap with each other
        int threadWait = rando.nextInt(100);
        
        while (true) {
            nextId = genny.generate();
            String insStatement = "insert into id_test (id, created, jvm) values ('" + nextId + "', " + System.currentTimeMillis() + ", '" + whoami + "')";
            //System.out.println(insStatement);
            st.executeUpdate(insStatement);
            Thread.sleep(threadWait);
        }
    }

}
