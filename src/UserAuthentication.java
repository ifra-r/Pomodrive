import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;

public class UserAuthentication {

    // Hash the password
    public static String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            hexString.append(String.format("%02x", b));
        }
        return hexString.toString();
    }

    // Register user
    public static boolean registerUser(String username, String password) {
        try (Connection conn = DriverManager.getConnection("jdbc:sqlite:focusboard.db")) {
            // Hash the password
            String hashedPassword = hashPassword(password);

            String sql = "INSERT INTO users (username, password_hash) VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, hashedPassword);
                int rowsAffected = stmt.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException | NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Verify user credentials
    public static boolean verifyUser(String username, String password) {
        try (Connection conn = DriverManager.getConnection("jdbc:sqlite:focusboard.db")) {
            // Hash the entered password
            String hashedPassword = hashPassword(password);

            String sql = "SELECT * FROM users WHERE username = ? AND password_hash = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, hashedPassword);
                ResultSet rs = stmt.executeQuery();

                // If we found a match, return true
                return rs.next();
            }
        } catch (SQLException | NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Main method for testing the registration and login
    public static void main(String[] args) {
        // Sample test data
        String username = "testuser";
        String password = "password123";

        // Test registration
        System.out.println("Testing User Registration:");
        if (registerUser(username, password)) {
            System.out.println("User registered successfully!");
        } else {
            System.out.println("User registration failed.");
        }

        // Test login
        System.out.println("\nTesting User Login:");
        if (verifyUser(username, password)) {
            System.out.println("User login successful!");
        } else {
            System.out.println("Invalid username or password.");
        }

        // Test failed login with incorrect password
        System.out.println("\nTesting User Login with Incorrect Password:");
        if (verifyUser(username, "wrongpassword")) {
            System.out.println("User login successful!");
        } else {
            System.out.println("Invalid username or password.");
        }
    }

}
