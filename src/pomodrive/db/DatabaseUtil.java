package pomodrive.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseUtil {
    private static String DB_URL = null; // Start with null, set later

    static {
        try {
            Class.forName("org.sqlite.JDBC");
            System.out.println("SQLite JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("SQLite JDBC Driver not found. Make sure sqlite-jdbc.jar is in classpath");
            throw new RuntimeException("SQLite JDBC Driver not found", e);
        }
    }

    public static void setDbPath(String path) {
        DB_URL = "jdbc:sqlite:" + path;
        System.out.println("Database URL set to: " + DB_URL);
    }

    public static Connection getConnection() throws SQLException {
        if (DB_URL == null || DB_URL.trim().isEmpty()) {
            throw new IllegalStateException("Database path not set. Call setDbPath() first.");
        }

        System.out.println("Attempting to connect to: " + DB_URL);

        try {
            Connection conn = DriverManager.getConnection(DB_URL);
            System.out.println(" Connection established successfully");

            // Enable foreign key support
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("PRAGMA foreign_keys = ON");
                System.out.println(" Foreign keys enabled");
            }

            System.out.println(" getConnection() completed successfully");
            return conn;

        } catch (SQLException e) {
            System.err.println("✗ SQLException in getConnection():");
            System.err.println("  Error Code: " + e.getErrorCode());
            System.err.println("  SQL State: " + e.getSQLState());
            System.err.println("  Message: " + e.getMessage());
            System.err.println("  DB_URL: " + DB_URL);
            e.printStackTrace();
            throw e; // Re-throw the exception
        } catch (Exception e) {
            System.err.println("✗ Unexpected exception in getConnection():");
            System.err.println("  Message: " + e.getMessage());
            System.err.println("  DB_URL: " + DB_URL);
            e.printStackTrace();
            throw new SQLException("Unexpected error connecting to database", e);
        }
    }

    public static void initializeSchema() throws SQLException {
        if (DB_URL == null) {
            throw new IllegalStateException("Database path not set. Call setDbPath() first.");
        }

        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement()) {

            // Create users table if it doesn't exist
            stmt.execute("""
                        CREATE TABLE IF NOT EXISTS users (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            username TEXT UNIQUE NOT NULL,
                            password_hash TEXT NOT NULL
                        )
                    """);

            // Create todos table matching the provided schema
            stmt.execute("""
                        CREATE TABLE IF NOT EXISTS todos (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            user_id INTEGER NOT NULL,
                            title TEXT NOT NULL,
                            description TEXT,
                            completed INTEGER DEFAULT 0,
                            priority INTEGER DEFAULT 2,
                            created_date TEXT DEFAULT (DATETIME('now')),
                            completed_date TEXT,
                            status TEXT DEFAULT 'pending',
                            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
                        )
                    """);

            // Create pomodoro_sessions table matching the provided schema
            stmt.execute("""
                        CREATE TABLE IF NOT EXISTS pomodoro_sessions (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            user_id INTEGER NOT NULL,
                            session_date TEXT DEFAULT (DATE('now')),
                            duration_minutes INTEGER NOT NULL,
                            completed INTEGER DEFAULT 1,
                            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
                        )
                    """);

            // Create index for better performance
            stmt.execute("CREATE INDEX IF NOT EXISTS idx_user_id ON todos(user_id)");
            // Add this line after your existing index creation:
            stmt.execute("CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON pomodoro_sessions(user_id)");

            // Add status column if it doesn't exist
            try {
                stmt.execute("ALTER TABLE todos ADD COLUMN status TEXT DEFAULT 'pending'");
            } catch (SQLException e) {
                if (!e.getMessage().contains("duplicate column name")) {
                    throw e;
                }
            }

            System.out.println("Database schema initialized successfully");
        }
    }

    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("Database connection successful!");
            System.out.println("Database URL: " + DB_URL);
        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}