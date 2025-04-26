package in.efficio.dao;

import in.efficio.model.Employee;
import in.efficio.model.Project;
import in.efficio.model.Task;
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

    // Existing methods (unchanged, as provided)
    public Optional<Employee> getEmployeeById(int employeeId) {
        String query = "SELECT e.employee_id, e.name AS employee_name, e.email, e.skills, " +
                      "e.rating, e.dob, e.status, d.department_name " +
                      "FROM employee e " +
                      "LEFT JOIN department d ON e.dept_id = d.department_id " +
                      "WHERE e.employee_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
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
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
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

    public List<Project> getProjectsForEmployee(int employeeId) {
        List<Project> projects = new ArrayList<>();
        String query = "SELECT p.project_id, p.project_name, wo.teamleader_id, tl.name AS teamleader_name " +
                      "FROM works_on wo " +
                      "JOIN project p ON wo.project_id = p.project_id " +
                      "LEFT JOIN team_leader tl ON wo.teamleader_id = tl.teamleader_id " +
                      "WHERE wo.employee_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
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
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
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
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching employee count", e);
        }
        return count;
    }

    public boolean deleteEmployee(int id) {
        String sql = "DELETE FROM employee WHERE employee_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            LOGGER.info("Deleted employee ID: " + id + ", rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting employee ID: " + id, e);
            return false;
        }
    }

    public List<Employee> getEmployeesByProject(int projectId) {
        List<Employee> employees = new ArrayList<>();
        String query = "SELECT e.employee_id, e.name, e.email, d.department_name " +
                      "FROM employee e " +
                      "JOIN works_on wo ON e.employee_id = wo.employee_id " +
                      "LEFT JOIN department d ON e.dept_id = d.department_id " +
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
                employee.setDept_name(rs.getString("department_name"));
                employees.add(employee);
            }
            LOGGER.info("Fetched " + employees.size() + " employees for project ID: " + projectId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching employees for project ID: " + projectId, e);
        }
        return employees;
    }

    public void updateSeenStatus(int employeeId, boolean isSeen) {
        String query = "UPDATE employee SET is_seen = ? WHERE employee_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setBoolean(1, isSeen);
            ps.setInt(2, employeeId);
            ps.executeUpdate();
            LOGGER.info("Updated seen status for employee ID: " + employeeId + " to " + isSeen);
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
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
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
                      "GROUP BY e.employee_id, e.name,e.email, d.department_name";
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
            LOGGER.info("Fetched " + employees.size() + " team members for team leader: " + teamLeaderName);
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
        Connection con = null;
        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false);

            // Get current assignments
            List<Integer> currentEmployeeIds = new ArrayList<>();
            String selectQuery = "SELECT employee_id FROM works_on WHERE project_id = ? AND employee_id IS NOT NULL";
            try (PreparedStatement ps = con.prepareStatement(selectQuery)) {
                ps.setInt(1, projectId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    currentEmployeeIds.add(rs.getInt("employee_id"));
                }
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
                String updateEmployeeQuery = "UPDATE employee SET assign_project_id = NULL, assign_teamleader_id = NULL WHERE employee_id = ? AND assign_project_id = ?";
                String deleteWorksOnQuery = "DELETE FROM works_on WHERE project_id = ? AND employee_id = ?";
                try (PreparedStatement updatePs = con.prepareStatement(updateEmployeeQuery);
                     PreparedStatement deletePs = con.prepareStatement(deleteWorksOnQuery)) {
                    for (Integer employeeId : employeesToRemove) {
                        updatePs.setInt(1, employeeId);
                        updatePs.setInt(2, projectId);
                        updatePs.addBatch();

                        deletePs.setInt(1, projectId);
                        deletePs.setInt(2, employeeId);
                        deletePs.addBatch();
                    }
                    updatePs.executeBatch();
                    int[] rows = deletePs.executeBatch();
                    LOGGER.info("Removed " + rows.length + " employees from project " + projectId);
                }
            }

            // Add employees
            if (!employeesToAdd.isEmpty()) {
                String updateEmployeeQuery = "UPDATE employee SET assign_project_id = ?, assign_teamleader_id = ? WHERE employee_id = ?";
                String insertWorksOnQuery = "INSERT INTO works_on (project_id, teamleader_id, employee_id) VALUES (?, ?, ?)";
                try (PreparedStatement updatePs = con.prepareStatement(updateEmployeeQuery);
                     PreparedStatement insertPs = con.prepareStatement(insertWorksOnQuery)) {
                    for (Integer employeeId : employeesToAdd) {
                        updatePs.setInt(1, projectId);
                        updatePs.setInt(2, teamLeaderId);
                        updatePs.setInt(3, employeeId);
                        updatePs.addBatch();

                        insertPs.setInt(1, projectId);
                        insertPs.setInt(2, teamLeaderId);
                        insertPs.setInt(3, employeeId);
                        insertPs.addBatch();
                    }
                    updatePs.executeBatch();
                    int[] rows = insertPs.executeBatch();
                    LOGGER.info("Added " + rows.length + " employees to project " + projectId);
                }
            }

            con.commit();
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error updating employee assignments for project " + projectId, e);
            throw new RuntimeException("Failed to update employee assignments", e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }

    public void assignEmployeeToProject(int employeeId, int projectId, int teamLeaderId) {
        Connection con = null;
        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false);

            // Check if already assigned
            String checkQuery = "SELECT COUNT(*) FROM works_on WHERE project_id = ? AND employee_id = ? AND teamleader_id = ?";
            try (PreparedStatement ps = con.prepareStatement(checkQuery)) {
                ps.setInt(1, projectId);
                ps.setInt(2, employeeId);
                ps.setInt(3, teamLeaderId);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    LOGGER.info("Employee " + employeeId + " already assigned to project " + projectId);
                    con.commit();
                    return;
                }
            }

            // Update employee table
            String updateEmployeeQuery = "UPDATE employee SET assign_project_id = ?, assign_teamleader_id = ? WHERE employee_id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateEmployeeQuery)) {
                ps.setInt(1, projectId);
                ps.setInt(2, teamLeaderId);
                ps.setInt(3, employeeId);
                ps.executeUpdate();
            }

            // Insert into works_on
            String insertWorksOnQuery = "INSERT INTO works_on (project_id, teamleader_id, employee_id) VALUES (?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insertWorksOnQuery)) {
                ps.setInt(1, projectId);
                ps.setInt(2, teamLeaderId);
                ps.setInt(3, employeeId);
                int rows = ps.executeUpdate();
                LOGGER.info("Assigned employee " + employeeId + " to project " + projectId + ": " + rows + " rows affected");
            }

            con.commit();
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error assigning employee " + employeeId + " to project " + projectId, e);
            throw new RuntimeException("Failed to assign employee to project: " + e.getMessage(), e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }

    public void removeEmployeeFromProject(int employeeId, int projectId) {
        Connection con = null;
        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false);

            // Update employee table
            String updateEmployeeQuery = "UPDATE employee SET assign_project_id = NULL, assign_teamleader_id = NULL WHERE employee_id = ? AND assign_project_id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateEmployeeQuery)) {
                ps.setInt(1, employeeId);
                ps.setInt(2, projectId);
                ps.executeUpdate();
            }

            // Delete from works_on
            String deleteWorksOnQuery = "DELETE FROM works_on WHERE employee_id = ? AND project_id = ?";
            try (PreparedStatement ps = con.prepareStatement(deleteWorksOnQuery)) {
                ps.setInt(1, employeeId);
                ps.setInt(2, projectId);
                int rows = ps.executeUpdate();
                LOGGER.info("Removed employee " + employeeId + " from project " + projectId + ": " + rows + " rows affected");
            }

            con.commit();
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error removing employee " + employeeId + " from project " + projectId, e);
            throw new RuntimeException("Failed to remove employee from project: " + e.getMessage(), e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }

    public String getTeamLeaderNameById(int teamLeaderId) {
        String query = "SELECT name FROM team_leader WHERE teamleader_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching team leader name for ID: " + teamLeaderId, e);
        }
        return "N/A";
    }
    
 // EmployeeDAO.java (Add this method)
    public List<Task> getTasksForEmployee(int employeeId) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT t.task_id, t.task_title, t.description, t.project_id, t.deadline_date, t.status, " +
                      "t.progress_percentage, t.assign_by_teamleader_id, t.assigned_to_employee_id, p.project_name " +
                      "FROM task t " +
                      "LEFT JOIN project p ON t.project_id = p.project_id " +
                      "WHERE t.assigned_to_employee_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setTaskTitle(rs.getString("task_title"));
                task.setDescription(rs.getString("description"));
                task.setProjectId(rs.getInt("project_id"));
                task.setDeadlineDate(rs.getDate("deadline_date"));
                task.setStatus(rs.getString("status"));
                task.setProgressPercentage(rs.getInt("progress_percentage"));
                task.setAssignByTeamLeaderId(rs.getInt("assign_by_teamleader_id"));
                task.setAssignedToEmployeeId(rs.getObject("assigned_to_employee_id") != null ? rs.getInt("assigned_to_employee_id") : null);
                task.setProjectName(rs.getString("project_name")); // Assuming Task model has projectName field
                tasks.add(task);
            }
            LOGGER.info("Fetched " + tasks.size() + " tasks for employee ID: " + employeeId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching tasks for employee ID: " + employeeId, e);
        }
        return tasks;
    }
}