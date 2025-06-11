package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;

public class HomeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("username") != null) {
            String username = (String) session.getAttribute("username");

            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<h1>Welcome, " + username + "!</h1>");
            out.println("<a href='logout'>Logout</a>");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
