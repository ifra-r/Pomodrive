import java.sql.*;

public class TestDatabaseOperations {

    // Database connection string
    private static final String DATABASE_URL = "jdbc:sqlite:focusboard.db";

    // Method to insert a new user
    public static void insertUser(String username, String passwordHash) {
        String insertUserSQL = "INSERT INTO users (username, password_hash) VALUES (?, ?)";

        try (Connection conn = DriverManager.getConnection(DATABASE_URL);
                PreparedStatement pstmt = conn.prepareStatement(insertUserSQL)) {

            pstmt.setString(1, username);
            pstmt.setString(2, passwordHash);
            pstmt.executeUpdate();
            System.out.println("User inserted successfully!");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    // Method to insert a Pomodoro session
    public static void insertPomodoroSession(int userId, int durationMinutes, int completed) {
        String insertSessionSQL = "INSERT INTO pomodoro_sessions (user_id, duration_minutes, completed) VALUES (?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(DATABASE_URL);
                PreparedStatement pstmt = conn.prepareStatement(insertSessionSQL)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, durationMinutes);
            pstmt.setInt(3, completed);
            pstmt.executeUpdate();
            System.out.println("Pomodoro session inserted successfully!");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    // Method to fetch Pomodoro sessions for a user
    public static void fetchPomodoroSessions(int userId) {
        String selectSessionsSQL = "SELECT * FROM pomodoro_sessions WHERE user_id = ?";

        try (Connection conn = DriverManager.getConnection(DATABASE_URL);
                PreparedStatement pstmt = conn.prepareStatement(selectSessionsSQL)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int sessionId = rs.getInt("id");
                int duration = rs.getInt("duration_minutes");
                int completed = rs.getInt("completed");
                System.out.println("Session ID: " + sessionId + ", Duration: " + duration + " minutes, Completed: "
                        + (completed == 1 ? "Yes" : "No"));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public static void main(String[] args) {
        // Test: Insert a new user
        insertUser("testUser", "hashed_password_123");

        // Assuming user ID is 1 for this example, add a Pomodoro session for the user
        insertPomodoroSession(1, 25, 1); // 25-minute session, completed

        // Fetch and display the Pomodoro sessions for the user
        fetchPomodoroSessions(1);
    }
}
