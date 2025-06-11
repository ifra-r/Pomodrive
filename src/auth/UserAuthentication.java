package auth;

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

    // // Register user
    // public static boolean registerUser(String username, String password, String
    // dbPath) {
    // try (Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath))
    // {
    // // Hash the password
    // String hashedPassword = hashPassword(password);

    // String sql = "INSERT INTO users (username, password_hash) VALUES (?, ?)";
    // try (PreparedStatement stmt = conn.prepareStatement(sql)) {
    // stmt.setString(1, username);
    // stmt.setString(2, hashedPassword);
    // int rowsAffected = stmt.executeUpdate();
    // return rowsAffected > 0;
    // }
    // } catch (SQLException | NoSuchAlgorithmException e) {
    // e.printStackTrace();
    // }
    // return false;
    // }

    public static boolean registerUser(String username, String password, String dbPath) {
        System.out.println("Registering user: " + username);
        System.out.println("Using DB path: " + dbPath);

        try (Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath)) {
            String hashedPassword = hashPassword(password);
            System.out.println("Hashed password: " + hashedPassword);

            String sql = "INSERT INTO users (username, password_hash) VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, hashedPassword);
                int rowsAffected = stmt.executeUpdate();
                System.out.println("Rows affected: " + rowsAffected);
                return rowsAffected > 0;
            }

        } catch (Exception e) {
            System.out.println("Registration failed: " + e.getMessage());
            e.printStackTrace(); // Important for line number + stack trace
            return false;
        }
    }

    // Verify user credentials
    public static boolean verifyUser(String username, String password, String dbPath) {
        try (Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath)) {
            // Hash the entered password
            String hashedPassword = hashPassword(password);

            String sql = "SELECT * FROM users WHERE username = ? AND password_hash = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, hashedPassword);
                ResultSet rs = stmt.executeQuery();

                return rs.next(); // true if a matching user was found
            }
        } catch (SQLException | NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return false;
    }
}
