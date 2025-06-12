package pomodrive.servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import pomodrive.dao.TodoDAO;
import pomodrive.model.Todo;
import pomodrive.db.DatabaseUtil;
import pomodrive.util.LocalDateTimeAdapter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/api/todos/*")
public class TodoRestServlet extends HttpServlet {
    private TodoDAO todoDAO = new TodoDAO();
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();

        try {
            // Match the path used throughout the app
            String relativePath = "/focusboard.db";
            String absolutePath = getServletContext().getRealPath(relativePath);

            System.out.println("Resolved DB path in servlet: " + absolutePath); // Debug log

            DatabaseUtil.setDbPath(absolutePath);
            DatabaseUtil.initializeSchema();
        } catch (Exception e) {
            throw new ServletException("************* Failed to initialize schema", e);
        }
    }

    private int getUserIdFromSession(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return -1;
        }

        String username = (String) session.getAttribute("username");

        // Use DatabaseUtil instead of direct SQLite connection
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement("SELECT id FROM users WHERE username = ?")) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return -1;
            }
        } catch (SQLException e) {
            System.err
                    .println("************* Error getting user ID for username: " + username + " - " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return -1;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = getUserIdFromSession(request, response);
        if (userId == -1)
            return;

        try {
            List<Todo> todos = todoDAO.getTodosByUserId(userId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(todos));
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = getUserIdFromSession(request, response);
        if (userId == -1)
            return;

        try {
            StringBuilder jsonBuilder = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonBuilder.append(line);
                }
            }

            String jsonString = jsonBuilder.toString();
            System.out.println("Received JSON: " + jsonString); // Debug log

            if (jsonString.trim().isEmpty()) {
                System.out.println("************* Empty JSON received");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            Todo todo = gson.fromJson(jsonString, Todo.class);
            System.out.println("Parsed Todo: " + todo.getTitle()); // Debug log

            todo.setUserId(userId);
            todo.setCreatedDate(LocalDateTime.now());

            // Set default values if not provided
            if (todo.getPriority() == 0) {
                todo.setPriority(1); // Default priority
            }
            if (todo.getDescription() == null) {
                todo.setDescription(""); // Default empty description
            }

            System.out.println("Creating todo for user: " + userId); // Debug log
            Todo createdTodo = todoDAO.createTodo(todo);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (createdTodo != null) {
                System.out.println("Todo created successfully with ID: " + createdTodo.getId());
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(createdTodo));
                out.flush();
            } else {
                System.out.println("************* Failed to create todo - DAO returned null");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            System.err.println("************* Error in doPost: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            // Send error details in response for debugging
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
            out.flush();
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = getUserIdFromSession(request, response);
        if (userId == -1)
            return;

        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.length() <= 1) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            int todoId;
            try {
                todoId = Integer.parseInt(pathInfo.substring(1));
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            StringBuilder jsonBuilder = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonBuilder.append(line);
                }
            }

            String jsonString = jsonBuilder.toString();
            if (jsonString.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            Todo todo = gson.fromJson(jsonString, Todo.class);
            todo.setId(todoId);
            todo.setUserId(userId);

            if (todo.isCompleted() && todo.getCompletedDate() == null) {
                todo.setCompletedDate(LocalDateTime.now());
            }

            boolean updated = todoDAO.updateTodo(todo);

            if (updated) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(todo));
                out.flush();
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = getUserIdFromSession(request, response);
        if (userId == -1)
            return;

        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.length() <= 1) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            int todoId;
            try {
                todoId = Integer.parseInt(pathInfo.substring(1));
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            boolean deleted = todoDAO.deleteTodo(todoId, userId);

            if (deleted) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}