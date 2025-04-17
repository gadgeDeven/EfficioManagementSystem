package in.efficio.dao;

import in.efficio.dbconnection.DbConnection;
import in.efficio.model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public boolean createNotification(Notification notification) {
        String query = "INSERT INTO notification (teamleader_id, type, message, project_id, task_id, is_seen) " +
                      "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, notification.getTeamleaderId());
            ps.setString(2, notification.getType());
            ps.setString(3, notification.getMessage());
            if (notification.getProjectId() != null) {
                ps.setInt(4, notification.getProjectId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (notification.getTaskId() != null) {
                ps.setInt(5, notification.getTaskId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setBoolean(6, notification.isSeen());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Notification> getNotifications(int teamLeaderId) {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT notification_id, teamleader_id, type, message, project_id, task_id, is_seen, created_at " +
                      "FROM notification WHERE teamleader_id = ? ORDER BY created_at DESC";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getInt("notification_id"));
                n.setTeamleaderId(rs.getInt("teamleader_id"));
                n.setType(rs.getString("type"));
                n.setMessage(rs.getString("message"));
                n.setProjectId(rs.getInt("project_id"));
                if (rs.wasNull()) n.setProjectId(null);
                n.setTaskId(rs.getInt("task_id"));
                if (rs.wasNull()) n.setTaskId(null);
                n.setSeen(rs.getBoolean("is_seen"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                notifications.add(n);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    public boolean markNotificationsAsSeen(int teamLeaderId) {
        String query = "UPDATE notification SET is_seen = TRUE WHERE teamleader_id = ? AND is_seen = FALSE";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getUnreadNotificationCount(int teamLeaderId) {
        String query = "SELECT COUNT(*) FROM notification WHERE teamleader_id = ? AND is_seen = FALSE";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, teamLeaderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}