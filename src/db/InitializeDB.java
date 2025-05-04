import java.sql.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.io.IOException;

public class InitializeDB {

    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection("jdbc:sqlite:focusboard.db")) {
            // Check if connection is successful
            if (conn != null) {
                System.out.println("Connection to SQLite has been established.");
                // Read and execute the schema SQL file
                String sql = new String(Files.readAllBytes(Paths.get("db/schema.sql")),
                        StandardCharsets.UTF_8);
                Statement stmt = conn.createStatement();
                stmt.executeUpdate(sql);
                System.out.println("Database initialized with schema.");
            }
        } catch (SQLException | IOException e) {
            e.printStackTrace();
        }
    }
}
