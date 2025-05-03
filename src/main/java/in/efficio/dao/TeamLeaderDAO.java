package in.efficio.dao;

import in.efficio.model.TeamLeader;
import in.efficio.model.Project;
import in.efficio.dbconnection.DbConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TeamLeaderDAO {
    private static final Logger LOGGER = Logger.getLogger(TeamLeaderDAO.class.getName());
    private final ProjectDAO projectDAO;

    public TeamLeaderDAO() {
        this.projectDAO = new ProjectDAO();
    }

    public List<TeamLeader> getAllTeamLeaders() {
        List<TeamLeader> teamLeaderList = new ArrayList<>();
        String query = "SELECT tl.teamleader_id, tl.name AS teamleader_name, tl.email, " +
                       "d.department_name, tl.assign_project_id, tl.profile_picture, " +
                       "tl.bio, tl.address, tl.skills, tl.dob " +
                       "FROM team_leader tl " +
                       "LEFT JOIN department d ON tl.department_id = d.department_id " +
                       "WHERE tl.status = 'Approved'";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TeamLeader tl = new TeamLeader();
                tl.setTeamleader_id(rs.getInt("teamleader_id"));
                tl.setName(rs.getString("teamleader_name"));
                tl.setEmail(rs.getString("email"));
                tl.setDepartment_name(rs.getString("department_name"));
                tl.setAssignProject_id(rs.getInt("assign_project_id"));
                tl.setProfile_picture(rs.getString("profile_picture"));
                tl.setBio(rs.getString("bio"));
                tl.setAddress(rs.getString("address"));
                tl.setSkills(rs.getString("skills"));
                tl.setDob(rs.getDate("dob"));
                // Fetch mobile number
                tl.setMobile_number(getMobileNumber(tl.getTeamleader_id()));
                // Fetch projects
                List<Project> projects = projectDAO.getProjects(tl.getTeamleader_id());
                tl.setProjects(projects);
                if (!projects.isEmpty() && tl.getAssignProject_id() != 0) {
                    tl.setAssign_project_name(projectDAO.getProjectName(tl.getAssignProject_id()));
                }
                teamLeaderList.add(tl);
                LOGGER.info("Fetched team leader ID: " + tl.getTeamleader_id() + " with " + projects.size() + " projects");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all team leaders", e);
        }
        return teamLeaderList;
    }

    public Optional<TeamLeader> getTeamLeaderById(int teamLeaderId) {
        String query = "SELECT tl.teamleader_id, tl.name AS teamleader_name, tl.email, tl.skills, " +
                       "tl.dob, tl.status, d.department_name, tl.assign_project_id, " +
                       "tl.profile_picture, tl.bio, tl.address " +
                       "FROM team_leader tl " +
                       "LEFT JOIN department d ON tl.department_id = d.department_id " +
                       "WHERE tl.teamleader_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TeamLeader tl = new TeamLeader();
                tl.setTeamleader_id(rs.getInt("teamleader_id"));
                tl.setName(rs.getString("teamleader_name"));
                tl.setEmail(rs.getString("email"));
                tl.setSkills(rs.getString("skills"));
                tl.setDob(rs.getDate("dob"));
                tl.setStatus(rs.getString("status"));
                tl.setDepartment_name(rs.getString("department_name"));
                tl.setAssignProject_id(rs.getInt("assign_project_id"));
                tl.setProfile_picture(rs.getString("profile_picture"));
                tl.setBio(rs.getString("bio"));
                tl.setAddress(rs.getString("address"));
                // Fetch mobile number
                tl.setMobile_number(getMobileNumber(teamLeaderId));
                // Fetch projects
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                tl.setProjects(projects);
                if (!projects.isEmpty() && tl.getAssignProject_id() != 0) {
                    tl.setAssign_project_name(projectDAO.getProjectName(tl.getAssignProject_id()));
                }
                LOGGER.info("Fetched team leader ID: " + teamLeaderId + " with " + projects.size() + " projects");
                return Optional.of(tl);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching team leader by ID: " + teamLeaderId, e);
        }
        return Optional.empty();
    }

    public int getTeamLeaderCount() {
        String query = "SELECT COUNT(*) FROM team_leader WHERE status = 'Approved'";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching team leader count", e);
        }
        return 0;
    }

    public boolean deleteTeamLeader(int id) {
        String sql = "DELETE FROM team_leader WHERE teamleader_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting team leader ID: " + id, e);
            return false;
        }
    }

    private String getMobileNumber(int teamLeaderId) {
        String query = "SELECT mobile_number FROM mobile_numbers WHERE role_type = 'TeamLeader' AND role_id = ?";
        try (Connection conn = DbConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("mobile_number");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching mobile number for team leader ID: " + teamLeaderId, e);
        }
        return null;
    }
}