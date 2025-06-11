package servlets;

import java.io.*;
import auth.UserAuthentication;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String dbPath = getServletContext().getRealPath("/focusboard.db");

        if (UserAuthentication.verifyUser(username, password, dbPath)) {
            // Success - start a session and redirect
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            response.sendRedirect("home.jsp");

        } else {
            // Failure - show login again with error
            request.setAttribute("errorMessage", "Invalid login credentials.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
    // public static void main(String[] args) {
    // System.err.println("ugh");
    // }
}
