package in.efficio.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import in.efficio.dbconnection.DbConnection;
import in.efficio.model.DashboardStats;

public class DashboardDAO {
    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        Connection con = DbConnection.getConnection();
        try {
            // Admin count (static for now, update if you have an admin table)
            PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM super_admin");
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) stats.setAdminCount(rs1.getInt(1));

            // Project counts
            PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM project");
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) stats.setProjectCount(rs2.getInt(1));

            PreparedStatement ps3 = con.prepareStatement("SELECT COUNT(*) FROM project WHERE status = 'Ongoing'");
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) stats.setPendingTaskCount(rs3.getInt(1));

            PreparedStatement ps4 = con.prepareStatement("SELECT COUNT(*) FROM project WHERE status = 'Completed'");
            ResultSet rs4 = ps4.executeQuery();
            if (rs4.next()) stats.setCompletedTaskCount(rs4.getInt(1));

            int totalTasks = stats.getPendingTaskCount() + stats.getCompletedTaskCount();
            stats.setProductivity(totalTasks > 0 ? (stats.getCompletedTaskCount() * 100.0) / totalTasks : 0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return stats;
    }
    
    public int getEmployeeProjectCount(int employeeId) {
        String query = "SELECT COUNT(*) FROM works_on WHERE employee_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            
            e.printStackTrace();
        }
        return 0;
    }

    public int getEmployeeTaskCount(int employeeId) {
        String query = "SELECT COUNT(*) FROM task WHERE assigned_to_employee_id = ?";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
           
            e.printStackTrace();
        }
        return 0;
    }

    public int getEmployeePendingTaskCount(int employeeId) {
        String query = "SELECT COUNT(*) FROM task WHERE assigned_to_employee_id = ? AND status = 'Pending'";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
           
            e.printStackTrace();
        }
        return 0;
    }

    public int getEmployeeCompletedTaskCount(int employeeId) {
        String query = "SELECT COUNT(*) FROM task WHERE assigned_to_employee_id = ? AND status = 'Completed'";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
           
            e.printStackTrace();
        }
        return 0;
    }
}