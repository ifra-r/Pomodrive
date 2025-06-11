package servlets;

import java.io.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import auth.UserAuthentication;

public class SignupServlet extends HttpServlet {
    // Handle POST request
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String dbPath = getServletContext().getRealPath("/focusboard.db");
        if (UserAuthentication.registerUser(username, password, dbPath)) {
            // On successful registration, redirect to login page
            response.sendRedirect("login.jsp");
        } else {
            // If registration fails, show an error message on the signup page
            request.setAttribute("errorMessage", "Registration failed. Try again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("signup.jsp");
            dispatcher.forward(request, response);
        }
    }
}
