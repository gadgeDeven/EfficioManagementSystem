package in.efficio.dao;

import in.efficio.dbconnection.DbConnection;
import in.efficio.model.Employee;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public Object getUserById(int userId, String role) {
        LOGGER.info("Fetching user for userId: " + userId + ", role: " + role);
        if ("Employee".equals(role)) {
            try (Connection conn = DbConnection.getConnection()) {
                if (conn == null) {
                    LOGGER.severe("Failed to get database connection");
                    return null;
                }

                String sql = "SELECT e.employee_id, e.name, e.email, e.skills, e.rating, e.dob, " +
                            "e.dept_id, d.department_name, e.assign_teamleader_id, t.name AS teamleader_name, " +
                            "e.assign_project_id, p.project_name AS assign_project_name, e.status, " +
                            "e.profile_picture, e.bio, e.address, m.mobile_number " +
                            "FROM employee e " +
                            "LEFT JOIN department d ON e.dept_id = d.department_id " +
                            "LEFT JOIN team_leader t ON e.assign_teamleader_id = t.teamleader_id " +
                            "LEFT JOIN project p ON e.assign_project_id = p.project_id " +
                            "LEFT JOIN mobile_numbers m ON m.role_type = 'Employee' AND m.role_id = e.employee_id " +
                            "WHERE e.employee_id = ?";
                
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        Employee employee = new Employee();
                        employee.setEmployee_id(rs.getInt("employee_id"));
                        employee.setName(rs.getString("name"));
                        employee.setEmail(rs.getString("email"));
                        employee.setSkills(rs.getString("skills"));
                        employee.setRating(rs.getFloat("rating"));
                        employee.setDob(rs.getDate("dob"));
                        employee.setDept_name(rs.getString("department_name"));
                        employee.setTeamLeader_name(rs.getString("teamleader_name"));
                        employee.setAssign_project_id(rs.getInt("assign_project_id"));
                        employee.setAssign_project_name(rs.getString("assign_project_name"));
                        employee.setStatus(rs.getString("status"));
                        employee.setProfile_picture(rs.getString("profile_picture"));
                        employee.setBio(rs.getString("bio"));
                        employee.setAddress(rs.getString("address"));
                        employee.setMobile_number(rs.getString("mobile_number"));
                        LOGGER.info("Successfully fetched employee with ID: " + userId);
                        return employee;
                    } else {
                        LOGGER.warning("No employee found with ID: " + userId);
                        return null;
                    }
                }
            } catch (SQLException e) {
                LOGGER.severe("Error fetching user for userId: " + userId + ", role: " + role + ": " + e.getMessage());
                e.printStackTrace();
                return null;
            }
        }
        LOGGER.warning("Unsupported role: " + role);
        return null;
    }
}