package pomodrive.dao;

import pomodrive.model.Todo;
import pomodrive.db.DatabaseUtil;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

public class TodoDAO {
    // Use ISO format for consistent date storage
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public List<Todo> getTodosByUserId(int userId) {
        List<Todo> todos = new ArrayList<>();
        String sql = "SELECT * FROM todos WHERE user_id = ? ORDER BY created_date DESC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                todos.add(mapResultSetToTodo(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting todos for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return todos;
    }

    public Todo createTodo(Todo todo) {
        String sql = "INSERT INTO todos (user_id, title, description, priority, created_date, completed) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, todo.getUserId());
            pstmt.setString(2, todo.getTitle());
            pstmt.setString(3, todo.getDescription());
            pstmt.setInt(4, todo.getPriority());
            pstmt.setString(5, formatDateTime(todo.getCreatedDate()));
            pstmt.setInt(6, todo.isCompleted() ? 1 : 0);

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = pstmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    todo.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating todo: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
        return todo;
    }

    public boolean updateTodo(Todo todo) {
        String sql = "UPDATE todos SET title = ?, description = ?, completed = ?, priority = ?, completed_date = ? WHERE id = ? AND user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, todo.getTitle());
            pstmt.setString(2, todo.getDescription());
            pstmt.setInt(3, todo.isCompleted() ? 1 : 0);
            pstmt.setInt(4, todo.getPriority());
            pstmt.setString(5, todo.getCompletedDate() != null ? formatDateTime(todo.getCompletedDate()) : null);
            pstmt.setInt(6, todo.getId());
            pstmt.setInt(7, todo.getUserId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating todo " + todo.getId() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTodo(int todoId, int userId) {
        String sql = "DELETE FROM todos WHERE id = ? AND user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, todoId);
            pstmt.setInt(2, userId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting todo " + todoId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public Todo getTodoById(int todoId, int userId) {
        String sql = "SELECT * FROM todos WHERE id = ? AND user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, todoId);
            pstmt.setInt(2, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToTodo(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting todo " + todoId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public int getTodoCountByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM todos WHERE user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting todo count for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int getCompletedTodoCountByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM todos WHERE user_id = ? AND completed = 1";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting completed todo count for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    private Todo mapResultSetToTodo(ResultSet rs) throws SQLException {
        Todo todo = new Todo();
        todo.setId(rs.getInt("id"));
        todo.setUserId(rs.getInt("user_id"));
        todo.setTitle(rs.getString("title"));
        todo.setDescription(rs.getString("description"));
        todo.setCompleted(rs.getInt("completed") == 1);
        todo.setPriority(rs.getInt("priority"));

        String createdDateStr = rs.getString("created_date");
        if (createdDateStr != null && !createdDateStr.isEmpty()) {
            try {
                todo.setCreatedDate(parseDateTime(createdDateStr));
            } catch (Exception e) {
                System.err.println("Error parsing created date: " + createdDateStr);
                todo.setCreatedDate(LocalDateTime.now());
            }
        }

        String completedDateStr = rs.getString("completed_date");
        if (completedDateStr != null && !completedDateStr.isEmpty()) {
            try {
                todo.setCompletedDate(parseDateTime(completedDateStr));
            } catch (Exception e) {
                System.err.println("Error parsing completed date: " + completedDateStr);
            }
        }

        return todo;
    }

    private String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null)
            return null;
        return dateTime.format(DATE_FORMATTER);
    }

    private LocalDateTime parseDateTime(String dateTimeStr) {
        if (dateTimeStr == null || dateTimeStr.trim().isEmpty())
            return null;

        try {
            // Try ISO format first (what we store)
            return LocalDateTime.parse(dateTimeStr, DATE_FORMATTER);
        } catch (DateTimeParseException e1) {
            try {
                // Try ISO format without time
                return LocalDateTime.parse(dateTimeStr + " 00:00:00", DATE_FORMATTER);
            } catch (DateTimeParseException e2) {
                try {
                    // Try standard ISO format
                    return LocalDateTime.parse(dateTimeStr);
                } catch (DateTimeParseException e3) {
                    System.err.println("Unable to parse date: " + dateTimeStr);
                    throw e3;
                }
            }
        }
    }
}