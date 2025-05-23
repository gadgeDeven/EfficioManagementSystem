package in.efficio.dao;

import in.efficio.dbconnection.DbConnection;
import in.efficio.model.Employee;
import in.efficio.model.Task;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TaskDAO {
    private static final Logger LOGGER = Logger.getLogger(TaskDAO.class.getName());
    private final Connection conn;

    public TaskDAO() {
        this.conn = DbConnection.getConnection();
    }

    // Existing methods (unchanged)
    public boolean createTask(Task task, int teamLeaderId) {
        String query = "INSERT INTO task (task_title, description, project_id, deadline_date, status, progress_percentage, assign_by_teamleader_id, assigned_to_employee_id, is_seen) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, task.getTaskTitle());
            ps.setString(2, task.getDescription());
            ps.setInt(3, task.getProjectId());
            ps.setDate(4, task.getDeadlineDate());
            ps.setString(5, task.getStatus());
            ps.setInt(6, task.getProgressPercentage());
            ps.setInt(7, teamLeaderId);
            ps.setNull(8, java.sql.Types.INTEGER);
            ps.setBoolean(9, false);
            int rowsAffected = ps.executeUpdate();
            System.out.println("Task inserted, rows affected: " + rowsAffected);

            // Update project progress
            ProjectDAO projectDAO = new ProjectDAO();
            int progress = projectDAO.calculateProjectProgress(task.getProjectId());
            projectDAO.updateProjectProgress(task.getProjectId(), progress);

            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void assignTaskToEmployee(int taskId, int employeeId, int projectId, int teamLeaderId) {
        String taskQuery = "UPDATE task SET assigned_to_employee_id = ?, is_seen = FALSE WHERE task_id = ?";
        String worksOnQuery = "UPDATE works_on SET task_id = ? WHERE project_id = ? AND teamleader_id = ? AND employee_id = ?";
        Connection con = null;
        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false);

            try (PreparedStatement taskPs = con.prepareStatement(taskQuery)) {
                taskPs.setInt(1, employeeId);
                taskPs.setInt(2, taskId);
                int taskRows = taskPs.executeUpdate();
                if (taskRows == 0) {
                    throw new SQLException("Task not found");
                }
            }

            try (PreparedStatement worksOnPs = con.prepareStatement(worksOnQuery)) {
                worksOnPs.setInt(1, taskId);
                worksOnPs.setInt(2, projectId);
                worksOnPs.setInt(3, teamLeaderId);
                worksOnPs.setInt(4, employeeId);
                int worksOnRows = worksOnPs.executeUpdate();
                if (worksOnRows == 0) {
                    throw new SQLException("No works_on entry found for employee " + employeeId + ", project " + projectId);
                }
            }

            con.commit();
            LOGGER.info("Assigned task " + taskId + " to employee " + employeeId + " for project " + projectId);
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Rollback failed", rollbackEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error assigning task " + taskId, e);
            throw new RuntimeException("Failed to assign task: " + e.getMessage(), e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException closeEx) {
                    LOGGER.log(Level.SEVERE, "Failed to close connection", closeEx);
                }
            }
        }
    }

    public List<Task> getTasksByTeamLeader(int teamLeaderId) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT t.task_id, t.task_title, t.description, t.project_id, t.deadline_date, t.status, t.progress_percentage, " +
                      "t.assign_by_teamleader_id, t.assigned_to_employee_id, t.is_seen " +
                      "FROM task t WHERE t.assign_by_teamleader_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
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
                task.setSeen(rs.getBoolean("is_seen"));
                tasks.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error fetching tasks for team leader: " + teamLeaderId, e);
        }
        return tasks;
    }

    public int getTaskCount(int teamLeaderId) {
        String query = "SELECT COUNT(*) FROM task t WHERE t.assign_by_teamleader_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error counting tasks for team leader: " + teamLeaderId, e);
        }
        return 0;
    }

    public int getPendingTaskCount(int teamLeaderId) {
        String query = "SELECT COUNT(*) FROM task t WHERE t.assign_by_teamleader_id = ? AND t.status = 'Pending'";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error counting pending tasks for team leader: " + teamLeaderId, e);
        }
        return 0;
    }

    public int getCompletedTaskCount(int teamLeaderId) {
        String query = "SELECT COUNT(*) FROM task t WHERE t.assign_by_teamleader_id = ? AND t.status = 'Completed'";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error counting completed tasks for team leader: " + teamLeaderId, e);
        }
        return 0;
    }

    public List<Task> getTasksByStatus(int teamLeaderId, String status) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT t.task_id, t.task_title, t.description, t.project_id, t.deadline_date, t.status, t.progress_percentage, " +
                      "t.assign_by_teamleader_id, t.assigned_to_employee_id, t.is_seen " +
                      "FROM task t WHERE t.assign_by_teamleader_id = ? AND t.status = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ps.setString(2, status);
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
                task.setSeen(rs.getBoolean("is_seen"));
                tasks.add(task);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching " + status + " tasks for team leader: " + teamLeaderId, e);
        }
        return tasks;
    }

    public List<Task> getTasksByProject(int projectId, int teamLeaderId) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT t.task_id, t.task_title, t.description, t.project_id, t.deadline_date, t.status, t.progress_percentage, " +
                      "t.assign_by_teamleader_id, t.assigned_to_employee_id, t.is_seen " +
                      "FROM task t WHERE t.project_id = ? AND t.assign_by_teamleader_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, projectId);
            ps.setInt(2, teamLeaderId);
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
                task.setSeen(rs.getBoolean("is_seen"));
                tasks.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error fetching tasks for projectId: " + projectId + ", teamLeaderId: " + teamLeaderId, e);
        }
        return tasks;
    }

    public void assignTask(int taskId, int employeeId) {
        String query = "UPDATE task SET assigned_to_employee_id = ?, is_seen = FALSE WHERE task_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, taskId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error assigning task " + taskId + " to employee " + employeeId, e);
        }
    }

    

    public void deleteTask(int taskId) {
        Connection con = null;
        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false);

            // Get project_id before deleting task
            String getProjectQuery = "SELECT project_id FROM task WHERE task_id = ?";
            int projectId = -1;
            try (PreparedStatement ps = con.prepareStatement(getProjectQuery)) {
                ps.setInt(1, taskId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    projectId = rs.getInt("project_id");
                }
            }

            // Delete from works_on
            String deleteWorksOnQuery = "DELETE FROM works_on WHERE task_id = ?";
            try (PreparedStatement ps = con.prepareStatement(deleteWorksOnQuery)) {
                ps.setInt(1, taskId);
                ps.executeUpdate();
            }

            // Delete task
            String deleteTaskQuery = "DELETE FROM task WHERE task_id = ?";
            try (PreparedStatement ps = con.prepareStatement(deleteTaskQuery)) {
                ps.setInt(1, taskId);
                ps.executeUpdate();
            }

            // Update project progress
            if (projectId != -1) {
                ProjectDAO projectDAO = new ProjectDAO();
                int progress = projectDAO.calculateProjectProgress(projectId);
                projectDAO.updateProjectProgress(projectId, progress);
            }

            con.commit();
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Rollback failed for task deletion: " + taskId, rollbackEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error deleting task ID: " + taskId, e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException closeEx) {
                    LOGGER.log(Level.SEVERE, "Failed to close connection after task deletion: " + taskId, closeEx);
                }
            }
        }
    }

    // New methods for Employee Dashboard
    public List<Task> getTasksByEmployeeId(int employeeId) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT t.task_id, t.task_title, t.description, t.project_id, t.deadline_date, t.status, t.progress_percentage, " +
                      "t.assign_by_teamleader_id, t.assigned_to_employee_id, t.is_seen, p.project_name " +
                      "FROM task t LEFT JOIN project p ON t.project_id = p.project_id " +
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
                task.setSeen(rs.getBoolean("is_seen"));
                task.setProjectName(rs.getString("project_name"));
                tasks.add(task);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching tasks for employee: " + employeeId, e);
        }
        return tasks;
    }

    public int getUnseenTaskNotificationsCount(int employeeId) {
        String query = "SELECT COUNT(*) FROM task WHERE assigned_to_employee_id = ? AND is_seen = FALSE";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting unseen task notifications for employee: " + employeeId, e);
        }
        return 0;
    }

    public void markTaskAsSeen(int taskId) {
        String query = "UPDATE task SET is_seen = TRUE WHERE task_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, taskId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking task as seen: " + taskId, e);
        }
    }
    
 

    

    

 // Fetch tasks by employee ID and status (new method)
    public List<Task> getTasksByEmployeeIdAndStatus(int employeeId, String status) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT t.task_id, t.task_title, t.description, t.project_id, t.deadline_date, t.status, t.progress_percentage, " +
                      "t.assign_by_teamleader_id, t.assigned_to_employee_id, t.is_seen, p.project_name " +
                      "FROM task t LEFT JOIN project p ON t.project_id = p.project_id " +
                      "WHERE t.assigned_to_employee_id = ?" +
                      (status != null ? " AND t.status = ?" : "");
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            if (status != null) {
                ps.setString(2, status);
            }
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
                task.setSeen(rs.getBoolean("is_seen"));
                task.setProjectName(rs.getString("project_name"));
                tasks.add(task);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching tasks for employee: " + employeeId + ", status: " + status, e);
        }
        return tasks;
    }

    // Task count methods (from previous response)
    public int getEmployeeTaskCount(int employeeId) {
        int count = 0;
        String query = "SELECT COUNT(*) AS task_count FROM task WHERE assigned_to_employee_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("task_count");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting tasks for employee: " + employeeId, e);
        }
        return count;
    }

    public int getEmployeePendingTaskCount(int employeeId) {
        int count = 0;
        String query = "SELECT COUNT(*) AS task_count FROM task WHERE assigned_to_employee_id = ? AND status = 'Pending'";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("task_count");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting pending tasks for employee: " + employeeId, e);
        }
        return count;
    }

    public int getEmployeeCompletedTaskCount(int employeeId) {
        int count = 0;
        String query = "SELECT COUNT(*) AS task_count FROM task WHERE assigned_to_employee_id = ? AND status = 'Completed'";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("task_count");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting completed tasks for employee: " + employeeId, e);
        }
        return count;
    }
    
    public Task getTaskById(int taskId) {
        Task task = null;
        String query = "SELECT t.task_id, t.task_title, t.description, t.project_id, t.deadline_date, t.status, t.progress_percentage, " +
                      "t.assign_by_teamleader_id, t.assigned_to_employee_id, t.is_seen, p.project_name, COALESCE(tl.name, 'Unknown') AS team_leader_name, t.progress_message " +
                      "FROM task t " +
                      "LEFT JOIN project p ON t.project_id = p.project_id " +
                      "LEFT JOIN team_leader tl ON t.assign_by_teamleader_id = tl.teamleader_id " +
                      "WHERE t.task_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setTaskTitle(rs.getString("task_title"));
                task.setDescription(rs.getString("description"));
                task.setProjectId(rs.getInt("project_id"));
                task.setDeadlineDate(rs.getDate("deadline_date"));
                task.setStatus(rs.getString("status"));
                task.setProgressPercentage(rs.getInt("progress_percentage"));
                task.setAssignByTeamLeaderId(rs.getInt("assign_by_teamleader_id"));
                task.setAssignedToEmployeeId(rs.getObject("assigned_to_employee_id") != null ? rs.getInt("assigned_to_employee_id") : null);
                task.setSeen(rs.getBoolean("is_seen"));
                task.setProjectName(rs.getString("project_name"));
                task.setTeamLeaderName(rs.getString("team_leader_name"));
                task.setProgressMessage(rs.getString("progress_message"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching task by ID: " + taskId, e);
        }
        return task;
    }

    public List<Employee> getEmployeesOnTask(int taskId) {
        List<Employee> employees = new ArrayList<>();
        String query = "SELECT e.employee_id, COALESCE(e.name, 'Unknown Employee') AS name " +
                      "FROM employee e " +
                      "JOIN works_on wo ON e.employee_id = wo.employee_id " +
                      "WHERE wo.task_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Employee emp = new Employee();
                emp.setEmployee_id(rs.getInt("employee_id"));
                emp.setName(rs.getString("name"));
                employees.add(emp);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching employees for task: " + taskId, e);
        }
        return employees;
    }
       

    public void updateTask(Task task) {
        String query = "UPDATE task SET task_title = ?, description = ?, deadline_date = ?, status = ?, progress_percentage = ?, is_seen = FALSE, progress_message = ? WHERE task_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, task.getTaskTitle());
            ps.setString(2, task.getDescription());
            ps.setDate(3, task.getDeadlineDate());
            ps.setString(4, task.getStatus());
            ps.setInt(5, task.getProgressPercentage());
            ps.setString(6, task.getProgressMessage());
            ps.setInt(7, task.getTaskId());
            ps.executeUpdate();

            // Update project progress
            ProjectDAO projectDAO = new ProjectDAO();
            int progress = projectDAO.calculateProjectProgress(task.getProjectId());
            projectDAO.updateProjectProgress(task.getProjectId(), progress);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating task ID: " + task.getTaskId(), e);
        }
    }
}