package in.efficio.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); // Get existing session (if any)
        
        if (session != null) {
            session.invalidate(); // Destroy session
        }
        
     // Set message attributes
        request.setAttribute("messageType", "Success");
        request.setAttribute("messageTitle", "Logged Out Successfully!");
        request.setAttribute("messageContent", "You have been logged out. Click below to login again.");
        request.setAttribute("redirectUrl", "LoginServlet");
        
        request.getRequestDispatcher("/views/notifications/messages.jsp").forward(request, response);
    }
}
