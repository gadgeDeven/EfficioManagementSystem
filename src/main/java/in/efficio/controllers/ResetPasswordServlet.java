package in.efficio.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import in.efficio.dbconnection.DbConnection;
import in.efficio.utils.PasswordHashing;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ResetPasswordServlet.class.getName());
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String code = request.getParameter("code");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null || role == null || code == null || password == null || confirmPassword == null) {
            request.setAttribute("message", "All fields are required!");
            request.getRequestDispatcher("views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("message", "Passwords do not match!");
            request.getRequestDispatcher("views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        Connection con = DbConnection.getConnection();
        if (con == null) {
            request.setAttribute("message", "Database connection failed!");
            request.getRequestDispatcher("views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        try {
            // Validate reset code
            String query = "SELECT reset_code, expires_at FROM password_reset_codes WHERE email=? AND role=? AND reset_code=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, role);
            ps.setString(3, code);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                java.sql.Timestamp expiresAt = rs.getTimestamp("expires_at");
                if (expiresAt.after(new java.sql.Timestamp(System.currentTimeMillis()))) {
                    // Code is valid and not expired
                    String hashedPassword = PasswordHashing.hashPassword(password);
                    String updateQuery = "";

                    if (role.equalsIgnoreCase("Admin")) {
                        updateQuery = "UPDATE super_admin SET password=? WHERE email=?";
                    } else if (role.equalsIgnoreCase("TeamLeader")) {
                        updateQuery = "UPDATE team_leader SET password=? WHERE email=?";
                    } else if (role.equalsIgnoreCase("Employee")) {
                        updateQuery = "UPDATE employee SET password=? WHERE email=?";
                    } else {
                        request.setAttribute("message", "Invalid Role Selected!");
                        request.getRequestDispatcher("views/auth/reset-password.jsp").forward(request, response);
                        return;
                    }

                    PreparedStatement psUpdate = con.prepareStatement(updateQuery);
                    psUpdate.setString(1, hashedPassword);
                    psUpdate.setString(2, email);
                    psUpdate.executeUpdate();

                    // Delete the used reset code
                    String deleteQuery = "DELETE FROM password_reset_codes WHERE email=? AND role=?";
                    PreparedStatement psDelete = con.prepareStatement(deleteQuery);
                    psDelete.setString(1, email);
                    psDelete.setString(2, role);
                    psDelete.executeUpdate();

                    request.setAttribute("message", "Password reset successfully! Please login.");
                    request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("message", "Reset code has expired!");
                    request.getRequestDispatcher("views/auth/reset-password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("message", "Invalid reset code!");
                request.getRequestDispatcher("views/auth/reset-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("views/auth/reset-password.jsp").forward(request, response);
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}