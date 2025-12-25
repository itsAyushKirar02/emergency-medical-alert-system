// In src/com/emergency/util/DBUtil.java
package com.emergency.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
    public static Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            String dbName = "emergency_system";
            String dbUser = System.getenv("DB_USER");
            String dbPass;
            String jdbcUrl;

            // Check if the code is running on Google App Engine
            if (System.getProperty("com.google.appengine.runtime.version") != null) {
                // --- RUNNING ON GOOGLE CLOUD ---
                dbPass = System.getenv("COUD_SQL_PASSWORD"); // <-- The password from Phase 2
                String instanceName = System.getenv("COUD_SQL_INSTANCE"); // <-- The name from Phase 3.1
                
                jdbcUrl = String.format("jdbc:mysql://google/%s?cloudSqlInstance=%s&socketFactory=com.google.cloud.sql.mysql.SocketFactory&user=%s&password=%s",
                                        dbName, instanceName, dbUser, dbPass);
            } else {
                // --- RUNNING ON YOUR LOCAL COMPUTER ---
                jdbcUrl = "jdbc:mysql://localhost:3306/emergency_system";
                dbUser = System.getenv("DB_USER");
                dbPass = System.getenv("DB_PASSWORD"); 
            }
            
            connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return connection;
    }
}