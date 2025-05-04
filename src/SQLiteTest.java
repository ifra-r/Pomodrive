// package com.focusboard;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SQLiteTest {

    public static void main(String[] args) {
        // Database URL
        String url = "jdbc:sqlite:focusboard.db"; // SQLite database file in the current directory

        // Test the connection
        try (Connection conn = DriverManager.getConnection(url)) {
            if (conn != null) {
                System.out.println("Connection to SQLite has been established.");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}

// public class TestSQLiteDriver {
// public static void main(String[] args) {
// try {
// Class.forName("org.sqlite.JDBC");
// System.out.println("✅ SQLite JDBC driver loaded successfully.");
// } catch (ClassNotFoundException e) {
// System.out.println("❌ JDBC driver not found! Did you add the .jar to
// classpath?");
// }
// }
// }
