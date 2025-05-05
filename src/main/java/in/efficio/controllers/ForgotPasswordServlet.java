package in.efficio.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import in.efficio.dbconnection.DbConnection;
import in.efficio.utils.EmailUtility;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("views/auth/forgot-password.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        String email = request.getParameter("email");

        if (role == null || email == null) {
            request.setAttribute("message", "All fields are required!");
            request.getRequestDispatcher("views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        Connection con = DbConnection.getConnection();
        if (con == null) {
            request.setAttribute("message", "Database connection failed!");
            request.getRequestDispatcher("views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            // Check if email exists for the selected role
            String query = "";
            if (role.equalsIgnoreCase("Admin")) {
                query = "SELECT email FROM super_admin WHERE email=?";
            } else if (role.equalsIgnoreCase("TeamLeader")) {
                query = "SELECT email FROM team_leader WHERE email=?";
            } else if (role.equalsIgnoreCase("Employee")) {
                query = "SELECT email FROM employee WHERE email=?";
            } else {
                request.setAttribute("message", "Invalid Role Selected!");
                request.getRequestDispatcher("views/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Generate a 6-digit reset code
                String resetCode = String.format("%06d", new Random().nextInt(999999));
                
                // Set expiration time (e.g., 30 minutes)
                String insertQuery = "INSERT INTO password_reset_codes (email, role, reset_code, expires_at) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL 30 MINUTE))";
                PreparedStatement psInsert = con.prepareStatement(insertQuery);
                psInsert.setString(1, email);
                psInsert.setString(2, role);
                psInsert.setString(3, resetCode);
                psInsert.executeUpdate();

                // Check if it's a demo email (e.g., contains "demo" or specific domain)
                boolean isDemoEmail = email.toLowerCase().contains("demo") || email.endsWith("@demo.com");

                if (isDemoEmail) {
                    // For demo emails, show the code on-screen or redirect
                    request.setAttribute("message", "Demo Reset Code: " + resetCode + ". Use this to reset your password.");
                    request.setAttribute("email", email);
                    request.setAttribute("role", role);
                    request.getRequestDispatcher("views/auth/reset-password.jsp").forward(request, response);
                } else {
                    // For real emails, send the code via email
                    String subject = "Efficio Password Reset Code";
                    String content = "Your password reset code is: " + resetCode + "\nThis code is valid for 30 minutes.";
                    EmailUtility.sendEmail(email, subject, content);

                    request.setAttribute("message", "A reset code has been sent to your email.");
                    request.setAttribute("email", email);
                    request.setAttribute("role", role);
                    request.getRequestDispatcher("views/auth/reset-password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("message", "No account exists with this email for the selected role!");
                request.getRequestDispatcher("views/auth/forgot-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("views/auth/forgot-password.jsp").forward(request, response);
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}