package in.efficio.dao;

import in.efficio.dbconnection.DbConnection;
import in.efficio.model.Employee;
import in.efficio.model.Project;
import in.efficio.model.TeamLeader;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProjectDAO {

	public int createProject(Project project) {
        String query = "INSERT INTO project (project_name, description, start_date, end_date, status, priority, admin_id) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, project.getProjectName());
            ps.setString(2, project.getDescription());
            ps.setDate(3, project.getStartDate());
            ps.setDate(4, project.getEndDate());
            ps.setString(5, project.getStatus());
            ps.setString(6, project.getPriority());
            ps.setInt(7, project.getAdminId());
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Return the generated project_id
                }
            }
            return -1; // Return -1 if insertion fails
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public List<Project> getAllProjects() {
        List<Project> projects = new ArrayList<>();
        String query = "SELECT * FROM project";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("project_id"));
                project.setProjectName(rs.getString("project_name"));
                project.setDescription(rs.getString("description"));
                project.setStartDate(rs.getDate("start_date"));
                project.setEndDate(rs.getDate("end_date"));
                project.setStatus(rs.getString("status"));
                project.setPriority(rs.getString("priority"));
                project.setAdminId(rs.getInt("admin_id"));
                projects.add(project);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return projects;
    }

    public Project getProjectById(int projectId) {
        String query = "SELECT * FROM project WHERE project_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("project_id"));
                project.setProjectName(rs.getString("project_name"));
                project.setDescription(rs.getString("description"));
                project.setStartDate(rs.getDate("start_date"));
                project.setEndDate(rs.getDate("end_date"));
                project.setStatus(rs.getString("status"));
                project.setPriority(rs.getString("priority"));
                project.setAdminId(rs.getInt("admin_id"));
                return project;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void deleteProject(int projectId) {
        Connection con = null;
        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false); // Start transaction

            // 1. Remove project references from team_leader (set assign_project_id to NULL)
            String updateTeamLeaderQuery = "UPDATE team_leader SET assign_project_id = NULL WHERE assign_project_id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateTeamLeaderQuery)) {
                ps.setInt(1, projectId);
                ps.executeUpdate();
            }

            // 2. Remove project references from employee (set assign_project_id to NULL)
            String updateEmployeeQuery = "UPDATE employee SET assign_project_id = NULL WHERE assign_project_id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateEmployeeQuery)) {
                ps.setInt(1, projectId);
                ps.executeUpdate();
            }

            // 3. Delete related records from works_on
            String deleteWorksOnQuery = "DELETE FROM works_on WHERE project_id = ?";
            try (PreparedStatement ps = con.prepareStatement(deleteWorksOnQuery)) {
                ps.setInt(1, projectId);
                ps.executeUpdate();
            }

            // 4. Delete the project from project table
            String deleteProjectQuery = "DELETE FROM project WHERE project_id = ?";
            try (PreparedStatement ps = con.prepareStatement(deleteProjectQuery)) {
                ps.setInt(1, projectId);
                ps.executeUpdate();
            }

            con.commit(); // Commit transaction
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback(); // Rollback on error
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            e.printStackTrace();
            throw new RuntimeException("Failed to delete project: " + e.getMessage());
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public void updateProjectStatus(int projectId, String status) {
        String query = "UPDATE project SET status = ? WHERE project_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, projectId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateProject(Project project) {
        String query = "UPDATE project SET project_name = ?, description = ? WHERE project_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, project.getProjectName());
            ps.setString(2, project.getDescription());
            ps.setInt(3, project.getProjectId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void updateProjectProgress(int projectId, int progress) {
        String sql = "UPDATE project SET progress = ? WHERE project_id = ?";
        try (Connection conn =  DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, progress);
            stmt.setInt(2, projectId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getProjectProgress(int projectId) {
        String sql = "SELECT progress FROM project WHERE project_id = ?";
        try (Connection conn = DbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("progress");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Default to 0 if not found or error
    }

    public List<Project> getProjectsByStatus(String status) {
        List<Project> projects = new ArrayList<>();
        String query = "SELECT * FROM project WHERE status = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("project_id"));
                project.setProjectName(rs.getString("project_name"));
                project.setDescription(rs.getString("description"));
                project.setStartDate(rs.getDate("start_date"));
                project.setEndDate(rs.getDate("end_date"));
                project.setStatus(rs.getString("status"));
                project.setPriority(rs.getString("priority"));
                project.setAdminId(rs.getInt("admin_id"));
                projects.add(project);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return projects;
    }

    public boolean assignTeamLeader(int projectId, int teamLeaderId) {
        Connection con = null;
        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false); // Start transaction

            // Update team_leader.assign_project_id
            String updateTeamLeaderQuery = "UPDATE team_leader SET assign_project_id = ? WHERE teamleader_id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateTeamLeaderQuery)) {
                ps.setInt(1, projectId);
                ps.setInt(2, teamLeaderId);
                ps.executeUpdate();
            }

            // Insert into works_on
            String insertWorksOnQuery = "INSERT INTO works_on (project_id, teamleader_id, employee_id, task_id) " +
                                       "VALUES (?, ?, NULL, NULL) " +
                                       "ON DUPLICATE KEY UPDATE project_id = project_id";
            try (PreparedStatement ps = con.prepareStatement(insertWorksOnQuery)) {
                ps.setInt(1, projectId);
                ps.setInt(2, teamLeaderId);
                ps.executeUpdate();
            }

            con.commit(); // Commit transaction
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback(); // Rollback on error
                    con.setAutoCommit(true);
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public boolean removeTeamLeader(int projectId, int teamLeaderId) {
        Connection con = null;
        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false); // Start transaction

            // Clear team_leader.assign_project_id
            String updateTeamLeaderQuery = "UPDATE team_leader SET assign_project_id = NULL WHERE teamleader_id = ? AND assign_project_id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateTeamLeaderQuery)) {
                ps.setInt(1, teamLeaderId);
                ps.setInt(2, projectId);
                ps.executeUpdate();
            }

            // Delete from works_on
            String deleteWorksOnQuery = "DELETE FROM works_on WHERE project_id = ? AND teamleader_id = ? AND employee_id IS NULL AND task_id IS NULL";
            try (PreparedStatement ps = con.prepareStatement(deleteWorksOnQuery)) {
                ps.setInt(1, projectId);
                ps.setInt(2, teamLeaderId);
                int rowsAffected = ps.executeUpdate();
                con.commit();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                    con.setAutoCommit(true);
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public List<TeamLeader> getAssignedTeamLeaders(int projectId) {
        List<TeamLeader> teamLeaders = new ArrayList<>();
        String query = "SELECT tl.teamleader_id, tl.name, tl.email " +
                      "FROM team_leader tl " +
                      "JOIN works_on wo ON tl.teamleader_id = wo.teamleader_id " +
                      "WHERE wo.project_id = ? AND wo.employee_id IS NULL AND wo.task_id IS NULL";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TeamLeader tl = new TeamLeader();
                tl.setTeamleader_id(rs.getInt("teamleader_id"));
                tl.setName(rs.getString("name"));
                tl.setEmail(rs.getString("email"));
                teamLeaders.add(tl);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teamLeaders;
    }

    private boolean isTeamLeaderAssigned(int projectId, int teamLeaderId) {
        String query = "SELECT COUNT(*) FROM works_on WHERE project_id = ? AND teamleader_id = ? AND employee_id IS NULL AND task_id IS NULL";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, projectId);
            ps.setInt(2, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
 // Updated getProjects to fetch projects by teamleader_id
    public List<Project> getProjects(int teamLeaderId) {
        List<Project> projects = new ArrayList<>();
        String query = "SELECT DISTINCT p.project_id, p.project_name, p.description, p.start_date, p.end_date, p.status, p.priority, p.admin_id " +
                      "FROM project p " +
                      "WHERE p.project_id IN (" +
                      "    SELECT assign_project_id FROM team_leader WHERE teamleader_id = ? AND assign_project_id IS NOT NULL " +
                      "    UNION " +
                      "    SELECT project_id FROM works_on WHERE teamleader_id = ? AND project_id IS NOT NULL" +
                      ")";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ps.setInt(2, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("project_id"));
                project.setProjectName(rs.getString("project_name"));
                project.setDescription(rs.getString("description"));
                project.setStartDate(rs.getDate("start_date"));
                project.setEndDate(rs.getDate("end_date"));
                project.setStatus(rs.getString("status"));
                project.setPriority(rs.getString("priority"));
                project.setAdminId(rs.getInt("admin_id"));
                projects.add(project);
            }
            System.out.println("Projects fetched for teamLeaderId " + teamLeaderId + ": " + projects.size());
            if (projects.isEmpty()) {
                System.out.println("No projects found for teamLeaderId " + teamLeaderId);
            } else {
                projects.forEach(p -> System.out.println("Project id: " + p.getProjectId() + ", name: " + p.getProjectName()));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            
        }
        return projects;
    }

    // Updated getProjectCount to count projects by teamleader_id
    public int getProjectCount(int teamLeaderId) {
        int count = 0;
        String query = "SELECT COUNT(*) FROM project p " +
                      "JOIN works_on wo ON p.project_id = wo.project_id " +
                      "WHERE wo.teamleader_id = ? AND wo.employee_id IS NULL AND wo.task_id IS NULL";
        
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }

    // Updated getProjectsByStatus to filter by teamleader_id
    public List<Project> getProjectsByStatusTeam(int teamLeaderId, String status) {
        List<Project> projects = new ArrayList<>();
        String query = "SELECT p.* FROM project p " +
                      "JOIN works_on wo ON p.project_id = wo.project_id " +
                      "WHERE wo.teamleader_id = ? AND p.status = ? AND wo.employee_id IS NULL AND wo.task_id IS NULL";
        
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("project_id"));
                project.setProjectName(rs.getString("project_name"));
                project.setDescription(rs.getString("description"));
                project.setStartDate(rs.getDate("start_date"));
                project.setEndDate(rs.getDate("end_date"));
                project.setStatus(rs.getString("status"));
                project.setPriority(rs.getString("priority"));
                project.setAdminId(rs.getInt("admin_id"));
                projects.add(project);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return projects;
    }

    // Helper method to get teamleader_id by email (assuming userName is email)
    public int getTeamLeaderIdByEmail(String email) {
        int teamLeaderId = -1;
        String query = "SELECT teamleader_id FROM team_leader WHERE email = ?";
        
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                teamLeaderId = rs.getInt("teamleader_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return teamLeaderId;
    }
    
    public String getProjectName(int projectId) {
        String query = "SELECT project_name FROM project WHERE project_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, projectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("project_name");
            }
        } catch (SQLException e) {
        	e.printStackTrace();
        }
        return "Unknown Project";
    }
    
 // In ProjectDAO.java
    public List<Project> getProjectsByEmployee(int employeeId) {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT p.project_id, p.project_name, p.description, p.start_date, p.end_date, p.status, p.priority " +
                     "FROM projects p JOIN project_assignments pa ON p.project_id = pa.project_id " +
                     "WHERE pa.employee_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, employeeId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Project project = new Project();
                project.setProjectId(rs.getInt("project_id"));
                project.setProjectName(rs.getString("project_name"));
                project.setDescription(rs.getString("description"));
                project.setStartDate(rs.getDate("start_date"));
                project.setEndDate(rs.getDate("end_date"));
                project.setStatus(rs.getString("status"));
                project.setPriority(rs.getString("priority"));
                projects.add(project);
            }
        } catch (SQLException e) {
        	e.printStackTrace();
        }
        return projects;
    }
    
   
}