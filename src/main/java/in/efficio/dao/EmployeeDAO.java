package in.efficio.dao;

import in.efficio.model.Employee;
import in.efficio.model.Project;
import in.efficio.dbconnection.DbConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmployeeDAO {
    private static final Logger LOGGER = Logger.getLogger(EmployeeDAO.class.getName());
    private final Connection conn;

    public EmployeeDAO() {
        this.conn = DbConnection.getConnection();
    }

    // Existing methods...
    public Optional<Employee> getEmployeeById(int employeeId) {
        String query = "SELECT e.employee_id, e.name AS employee_name, e.email, e.skills, " +
                      "e.rating, e.dob, e.status, d.department_name " +
                      "FROM employee e " +
                      "LEFT JOIN department d ON e.dept_id = d.department_id " +
                      "WHERE e.employee_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Employee emp = new Employee();
                    emp.setEmployee_id(rs.getInt("employee_id"));
                    emp.setName(rs.getString("employee_name"));
                    emp.setEmail(rs.getString("email"));
                    emp.setSkills(rs.getString("skills"));
                    emp.setRating(rs.getFloat("rating"));
                    emp.setDob(rs.getDate("dob"));
                    emp.setDept_name(rs.getString("department_name"));
                    emp.setStatus(rs.getString("status"));
                    List<Project> projects = getProjectsForEmployee(employeeId);
                    emp.setProjects(projects);
                    LOGGER.info("Fetched employee ID: " + employeeId + " with " + projects.size() + " projects");
                    return Optional.of(emp);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching employee by ID: " + employeeId, e);
        }
        return Optional.empty();
    }

    public List<Employee> getAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        String query = "SELECT e.employee_id, e.name AS employee_name, e.email, e.skills, " +
                      "e.rating, e.dob, e.status, d.department_name " +
                      "FROM employee e " +
                      "LEFT JOIN department d ON e.dept_id = d.department_id";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Employee emp = new Employee();
                emp.setEmployee_id(rs.getInt("employee_id"));
                emp.setName(rs.getString("employee_name"));
                emp.setEmail(rs.getString("email"));
                emp.setSkills(rs.getString("skills"));
                emp.setRating(rs.getFloat("rating"));
                emp.setDob(rs.getDate("dob"));
                emp.setDept_name(rs.getString("department_name"));
                emp.setStatus(rs.getString("status"));
                List<Project> projects = getProjectsForEmployee(emp.getEmployee_id());
                emp.setProjects(projects);
                Set<Integer> teamLeaderIds = getTeamLeaderIdsForEmployee(emp.getEmployee_id());
                emp.setTeamLeaderIds(teamLeaderIds);
                employees.add(emp);
                LOGGER.info("Fetched employee ID: " + emp.getEmployee_id() + " with TL IDs: " + teamLeaderIds + ", projects: " + projects.size());
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all employees", e);
        }
        return employees;
    }

    private List<Project> getProjectsForEmployee(int employeeId) {
        List<Project> projects = new ArrayList<>();
        String query = "SELECT p.project_id, p.project_name, wo.teamleader_id, tl.name AS teamleader_name " +
                      "FROM works_on wo " +
                      "JOIN project p ON wo.project_id = p.project_id " +
                      "LEFT JOIN team_leader tl ON wo.teamleader_id = tl.teamleader_id " +
                      "WHERE wo.employee_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int projectId = rs.getInt("project_id");
                String projectName = rs.getString("project_name");
                Integer teamLeaderId = rs.getInt("teamleader_id");
                String teamLeaderName = rs.getString("teamleader_name");
                if (rs.wasNull()) {
                    teamLeaderId = null;
                    teamLeaderName = null;
                }
                Project project = new Project(
                    projectId,
                    projectName,
                    teamLeaderId,
                    teamLeaderName
                );
                projects.add(project);
                LOGGER.info("Employee ID: " + employeeId + 
                           ", Project ID: " + projectId + 
                           ", Name: " + (projectName != null ? projectName : "null") + 
                           ", TL ID: " + (teamLeaderId != null ? teamLeaderId : "null") + 
                           ", TL Name: " + (teamLeaderName != null ? teamLeaderName : "null"));
            }
            if (projects.isEmpty()) {
                LOGGER.info("No projects found for employee ID: " + employeeId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching projects for employee ID: " + employeeId, e);
        }
        return projects;
    }

    private Set<Integer> getTeamLeaderIdsForEmployee(int employeeId) {
        Set<Integer> teamLeaderIds = new HashSet<>();
        String query = "SELECT DISTINCT wo.teamleader_id " +
                      "FROM works_on wo " +
                      "WHERE wo.employee_id = ? AND wo.teamleader_id IS NOT NULL";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int teamLeaderId = rs.getInt("teamleader_id");
                if (!rs.wasNull()) {
                    teamLeaderIds.add(teamLeaderId);
                }
            }
            if (teamLeaderIds.isEmpty()) {
                LOGGER.info("No team leader IDs found for employee ID: " + employeeId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching team leader IDs for employee ID: " + employeeId, e);
        }
        return teamLeaderIds;
    }

    public int getEmployeeCount() {
        int count = 0;
        String query = "SELECT COUNT(*) FROM employee WHERE status = 'Approved'";
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public boolean deleteEmployee(int id) {
        String sql = "DELETE FROM employee WHERE employee_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Employee> getEmployeesByProject(int projectId) {
        List<Employee> employees = new ArrayList<>();
        String query = "SELECT e.employee_id, e.name, e.email " +
                      "FROM employee e " +
                      "JOIN works_on wo ON e.employee_id = wo.employee_id " +
                      "WHERE wo.project_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Employee employee = new Employee();
                employee.setEmployee_id(rs.getInt("employee_id"));
                employee.setName(rs.getString("name"));
                employee.setEmail(rs.getString("email"));
                employees.add(employee);
            }
            // Debug logging
            System.out.println("Fetched " + employees.size() + " employees for project ID: " + projectId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching employees for project ID: " + projectId, e);
        }
        return employees;
    }

    public void updateSeenStatus(int employeeId, boolean isSeen) {
        String query = "UPDATE employee SET is_seen = ? WHERE employee_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setBoolean(1, isSeen);
            ps.setInt(2, employeeId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating seen status for employee ID: " + employeeId, e);
        }
    }

    public int getTeamSize(String teamLeaderName) {
        int count = 0;
        String query = "SELECT COUNT(*) " +
                      "FROM employee e " +
                      "JOIN team_leader tl ON e.assign_teamleader_id = tl.teamleader_id " +
                      "WHERE tl.name = ? AND e.status = 'Approved'";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, teamLeaderName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching team size for team leader: " + teamLeaderName, e);
        }
        return count;
    }

    public List<Employee> getTeamMembers(String teamLeaderName) {
        List<Employee> employees = new ArrayList<>();
        String query = "SELECT DISTINCT e.employee_id, e.name, e.email, d.department_name, GROUP_CONCAT(DISTINCT p.project_name) AS project_names " +
                      "FROM employee e " +
                      "LEFT JOIN department d ON e.dept_id = d.department_id " +
                      "LEFT JOIN works_on wo ON e.employee_id = wo.employee_id " +
                      "LEFT JOIN project p ON wo.project_id = p.project_id " +
                      "LEFT JOIN team_leader tl ON wo.teamleader_id = tl.teamleader_id " +
                      "WHERE tl.name = ? AND e.status = 'Approved' " +
                      "GROUP BY e.employee_id, e.name, e.email, d.department_name";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, teamLeaderName);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Employee employee = new Employee();
                employee.setEmployee_id(rs.getInt("employee_id"));
                employee.setName(rs.getString("name"));
                employee.setEmail(rs.getString("email"));
                employee.setDept_name(rs.getString("department_name"));
                employee.setAssign_project_name(rs.getString("project_names"));
                employees.add(employee);
            }
            System.out.println("Fetched " + employees.size() + " team members for team leader: " + teamLeaderName);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching team members for team leader " + teamLeaderName, e);
        }
        return employees;
    }
    
    

    

    public boolean isEmployeeAssignedToProject(int employeeId, int projectId) {
        String query = "SELECT COUNT(*) FROM works_on WHERE employee_id = ? AND project_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, projectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking assignment for employee " + employeeId + " and project " + projectId, e);
        }
        return false;
    }

    public void updateEmployeeAssignments(int projectId, int teamLeaderId, List<Integer> employeeIds) {
        // Get current assignments
        List<Integer> currentEmployeeIds = new ArrayList<>();
        String selectQuery = "SELECT employee_id FROM works_on WHERE project_id = ? AND employee_id IS NOT NULL";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(selectQuery)) {
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                currentEmployeeIds.add(rs.getInt("employee_id"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching current assignments for project " + projectId, e);
        }

        // Determine employees to add and remove
        List<Integer> employeesToAdd = new ArrayList<>(employeeIds != null ? employeeIds : new ArrayList<>());
        employeesToAdd.removeAll(currentEmployeeIds);
        List<Integer> employeesToRemove = new ArrayList<>(currentEmployeeIds);
        if (employeeIds != null) {
            employeesToRemove.removeAll(employeeIds);
        }

        // Remove employees
        if (!employeesToRemove.isEmpty()) {
            String deleteQuery = "DELETE FROM works_on WHERE project_id = ? AND employee_id = ?";
            try (Connection con = DbConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(deleteQuery)) {
                for (Integer employeeId : employeesToRemove) {
                    ps.setInt(1, projectId);
                    ps.setInt(2, employeeId);
                    ps.addBatch();
                }
                int[] rows = ps.executeBatch();
                System.out.println("Removed " + rows.length + " employees from project " + projectId);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error removing employees from project " + projectId, e);
            }
        }

        // Add employees
        if (!employeesToAdd.isEmpty()) {
            String insertQuery = "INSERT INTO works_on (project_id, teamleader_id, employee_id, assign_project_id) VALUES (?, ?, ?, ?)";
            try (Connection con = DbConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(insertQuery)) {
                for (Integer employeeId : employeesToAdd) {
                    ps.setInt(1, projectId);
                    ps.setInt(2, teamLeaderId);
                    ps.setInt(3, employeeId);
                    ps.setInt(4, projectId);
                    ps.addBatch();
                }
                int[] rows = ps.executeBatch();
                System.out.println("Added " + rows.length + " employees to project " + projectId);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error adding employees to project " + projectId, e);
            }
        }
    }

    public void assignEmployeeToProject(int employeeId, int projectId, int teamLeaderId) {
        // Check if already assigned
        String checkQuery = "SELECT COUNT(*) FROM works_on WHERE project_id = ? AND employee_id = ? AND teamleader_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(checkQuery)) {
            ps.setInt(1, projectId);
            ps.setInt(2, employeeId);
            ps.setInt(3, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                System.out.println("Employee " + employeeId + " already assigned to project " + projectId);
                return;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking assignment for employee " + employeeId + " and project " + projectId, e);
            throw new RuntimeException("Failed to check existing assignment", e);
        }

        // Assign employee
        String query = "INSERT INTO works_on (project_id, teamleader_id, employee_id) VALUES (?, ?, ?)";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, projectId);
            ps.setInt(2, teamLeaderId);
            ps.setInt(3, employeeId);
            int rows = ps.executeUpdate();
            System.out.println("Assigned employee " + employeeId + " to project " + projectId + ": " + rows + " rows affected");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error assigning employee " + employeeId + " to project " + projectId, e);
            throw new RuntimeException("Failed to assign employee to project: " + e.getMessage(), e);
        }
    }

    public void removeEmployeeFromProject(int employeeId, int projectId) {
        String query = "DELETE FROM works_on WHERE employee_id = ? AND project_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, projectId);
            int rows = ps.executeUpdate();
            System.out.println("Removed employee " + employeeId + " from project " + projectId + ": " + rows + " rows affected");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error removing employee " + employeeId + " from project " + projectId, e);
            throw new RuntimeException("Failed to remove employee from project: " + e.getMessage(), e);
        }
    }
}