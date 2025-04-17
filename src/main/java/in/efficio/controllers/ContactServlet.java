package in.efficio.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import in.efficio.dbconnection.DbConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Form se data lo
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        Connection con = null;
        PreparedStatement stmt = null;

        try {
            // DbConnection class se connection lo
            con = DbConnection.getConnection();

            // SQL query to insert data
            String sql = "INSERT INTO contact_data (name, email, message) VALUES (?, ?, ?)";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, message);

            // Query execute karo
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                // Success case
                request.setAttribute("messageType", "Success");
                request.setAttribute("messageTitle", "Message Sent Successfully!");
                request.setAttribute("messageContent", "Thank you for reaching out. We'll get back to you soon.");
                request.setAttribute("redirectUrl", "index.jsp"); // Home page ya koi aur URL
            } else {
                // Pending case (e.g., agar koi manual review chahiye)
                request.setAttribute("messageType", "Pending");
                request.setAttribute("messageTitle", "Message Under Review");
                request.setAttribute("messageContent", "Your message has been received and is awaiting processing.");
                request.setAttribute("redirectUrl", "index.jsp");
            }

            // Message JSP pe forward karo
            request.getRequestDispatcher("/views/notifications/messages.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Error case
            request.setAttribute("messageType", "Rejected");
            request.setAttribute("messageTitle", "Submission Failed");
            request.setAttribute("messageContent", "Something went wrong while sending your message. Please try again.");
            request.setAttribute("redirectUrl", "index.html");

            // Message JSP pe forward karo
            request.getRequestDispatcher("/message.jsp").forward(request, response);
        } finally {
            // Resources close karo
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}