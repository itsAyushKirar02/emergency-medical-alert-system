package com.emergency.util;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

@WebListener
public class WebAppLifecycleListener implements ServletContextListener {

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // This method is called when the application shuts down.
        System.out.println("Web application is shutting down. Cleaning up resources...");

        // Deregister all JDBC drivers
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                System.out.println("Deregistering JDBC driver: " + driver.getClass().getName());
            } catch (SQLException e) {
                System.err.println("Error deregistering JDBC driver: " + driver.getClass().getName());
                e.printStackTrace();
            }
        }

        // Shut down the MySQL cleanup thread
        try {
            AbandonedConnectionCleanupThread.uncheckedShutdown();
            System.out.println("MySQL cleanup thread shutdown command issued.");
        } catch (Exception e) {
            System.err.println("Error shutting down MySQL connection cleanup thread: " + e.getMessage());
        }
    }
}