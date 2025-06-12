package pomodrive.db;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;

public class TestTodoDb {
    public static void main(String[] args) {
        try {
            String dbPath = new File("db/pomodrive.db").getAbsolutePath();
            System.out.println("Resolved path: " + dbPath);

            // String dbPath = "db/pomodrive.db";
            String url = "jdbc:sqlite:" + dbPath;

            // Create DB and table
            try (Connection conn = DriverManager.getConnection(url);
                    Statement stmt = conn.createStatement()) {

                System.out.println("Connected to DB at " + dbPath);

                String createTable = "CREATE TABLE IF NOT EXISTS todos (" +
                        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                        "title TEXT NOT NULL," +
                        "description TEXT," +
                        "priority INTEGER)";
                stmt.executeUpdate(createTable);
                System.out.println("Table initialized");

                // Insert test task
                String insert = "INSERT INTO todos (title, description, priority) " +
                        "VALUES ('Test Task', 'This is a test', 1)";
                stmt.executeUpdate(insert);
                System.out.println("Inserted test task");

                // Read back tasks
                ResultSet rs = stmt.executeQuery("SELECT * FROM todos");
                while (rs.next()) {
                    System.out.println("Task: " + rs.getString("title") + " - " + rs.getString("description"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
