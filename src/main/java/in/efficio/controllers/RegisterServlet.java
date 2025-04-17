package in.efficio.controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import in.efficio.dao.DepartmentDAO;
import in.efficio.dbconnection.DbConnection;
import in.efficio.model.Department;
import in.efficio.utils.PasswordHashing;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UserRegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fetch departments for dropdown
        List<Department> deptList = new DepartmentDAO().getAllDepartments();
        request.setAttribute("departmentList", deptList);

        RequestDispatcher rd = request.getRequestDispatcher("views/auth/user-registration.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	

        String role = request.getParameter("role").trim();
        String name = request.getParameter("name").trim();
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();
        String confirmPassword = request.getParameter("confirmPassword").trim();
        String deptIdStr = request.getParameter("department").trim();
        String skill = request.getParameter("skills").trim();
        String dob = request.getParameter("dob").trim();
        
        // Validate password match
        if (!password.equals(confirmPassword)) {
            sendError(request, response, "Passwords do not match!", role);
            return;
        }

        int deptId1 = Integer.parseInt(deptIdStr);

        try (Connection conn = DbConnection.getConnection()) {
            // Check if email is already registered
            String checkEmailQuery = role.equalsIgnoreCase("Team Leader")
                    ? "SELECT COUNT(*) FROM team_leader WHERE email = ?"
                    : "SELECT COUNT(*) FROM employee WHERE email = ?";

            try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailQuery)) {
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    sendError(request, response, "Email already registered. Please use a different email.", role);
                    return;
                }
            }

            // Hash password
            String hashedPassword = PasswordHashing.hashPassword(password);

            // Insert user based on role
            String query = (role.equalsIgnoreCase("Team Leader") || role.equalsIgnoreCase("TeamLeader"))  
            	    ? "INSERT INTO team_leader (name, email, password, department_id, skills, dob, status) VALUES (?, ?, ?, ?, ?, ?, 'Pending')"  
            	    : "INSERT INTO employee (name, email, password, dept_id, skills, dob, status) VALUES (?, ?, ?, ?, ?, ?, 'Pending')";

            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, hashedPassword);
                ps.setInt(4, deptId1);
                ps.setString(5, skill);
                ps.setString(6, dob);

                if (ps.executeUpdate() > 0) {
                	request.setAttribute("messageType", "Success");
                    request.setAttribute("messageTitle", "Registration Successful!");
                    request.setAttribute("messageContent", "Your registration has been submitted and is awaiting approval.");
                    request.setAttribute("redirectUrl", "LoginServlet");
                    RequestDispatcher rd = request.getRequestDispatcher("/views/notifications/messages.jsp");
                    rd.forward(request, response);
                } else {
                    sendError(request, response, "Registration failed. Please try again.", role);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            sendError(request, response, "Database error! Please try again later.", role);
        }
    }

    // Send error messages with department list
    private void sendError(HttpServletRequest request, HttpServletResponse response, String errorMsg, String role)
            throws ServletException, IOException {
        List<Department> deptList = new DepartmentDAO().getAllDepartments();
        request.setAttribute("departmentList", deptList);
        request.setAttribute("errorMessage", errorMsg);
        request.setAttribute("role", role);
        RequestDispatcher rd = request.getRequestDispatcher("views/auth/user-registration.jsp");
        rd.forward(request, response);
    }
}
