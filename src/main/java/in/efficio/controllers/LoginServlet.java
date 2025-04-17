package in.efficio.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import in.efficio.dbconnection.DbConnection;
import in.efficio.utils.PasswordHashing;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    RequestDispatcher rd = request.getRequestDispatcher("views/auth/login.jsp");
	    rd.forward(request, response);
	}
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (role == null || email == null || password == null) {
            request.setAttribute("message", "All fields are required!");
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
            return;
        }

        Connection con = DbConnection.getConnection();
        if (con == null) {
            request.setAttribute("message", "Database connection failed!");
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
            return;
        }

        try {
            String query = "";
            
            if (role.equalsIgnoreCase("Admin")) {
                query = "SELECT * FROM super_admin WHERE email=?";
            } else if (role.equalsIgnoreCase("TeamLeader")) {
                query = "SELECT * FROM team_leader WHERE email=?";
            } else if (role.equalsIgnoreCase("Employee")) {
                query = "SELECT * FROM employee WHERE email=?";
            } else {
                request.setAttribute("message", "Invalid Role Selected!");
                request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
                return;
            }

            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String dbPassword = rs.getString("password");
                String name = rs.getString("name");

                if (!role.equalsIgnoreCase("Admin")) {
                    String status = rs.getString("status");
                    if (status.equalsIgnoreCase("Pending")) {
                        request.setAttribute("messageType", "Pending");
                        request.setAttribute("messageTitle", "Account Under Review");
                        request.setAttribute("messageContent", "Your account is under review. Please wait for admin approval!");
                        request.setAttribute("redirectUrl", "LoginServlet");
                        request.getRequestDispatcher("/views/notifications/messages.jsp").forward(request, response);
                        return;
                    } else if (status.equalsIgnoreCase("Rejected")) {
                        request.setAttribute("messageType", "Rejected");
                        request.setAttribute("messageTitle", "Account Rejected");
                        request.setAttribute("messageContent", "Your account has been rejected. Contact admin for more details!");
                        request.setAttribute("redirectUrl", "LoginServlet");
                        request.getRequestDispatcher("/views/notifications/messages.jsp").forward(request, response);
                        return;
                    }
                }

                String hashedInputPassword = PasswordHashing.hashPassword(password);
                if (dbPassword.equals(hashedInputPassword)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userName", email); // Changed to email instead of name
                    session.setAttribute("userRole", role);
                    session.setAttribute("displayName", name); // Optional: store name separately for display

                    if (role.equalsIgnoreCase("Admin")) {
                        response.sendRedirect(request.getContextPath() + "/DashboardServlet");
                    } else if (role.equalsIgnoreCase("TeamLeader")) {
                        response.sendRedirect(request.getContextPath() + "/TeamLeaderDashboard"); // Fixed servlet name
                    } else if (role.equalsIgnoreCase("Employee")) {
                        response.sendRedirect(request.getContextPath() + "/views/dashboards/employee/employee-dashboard.jsp");
                    }
                } else {
                    request.setAttribute("message", "Incorrect Password! Please try again.");
                    request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("message", "No account exists with this email for the selected role!");
                request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}