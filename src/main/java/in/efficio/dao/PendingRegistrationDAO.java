package in.efficio.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import in.efficio.dbconnection.DbConnection;
import in.efficio.model.PendingRegistration;

public class PendingRegistrationDAO {

    public List<PendingRegistration> getPendingRegistrations() {
        List<PendingRegistration> registrations = new ArrayList<>();
        Connection con = DbConnection.getConnection();
        try {
            PreparedStatement ps = con.prepareStatement(
                "SELECT tl.teamleader_id AS id, 'Team Leader' AS role, tl.name, tl.email, d.department_name AS department, tl.status, tl.is_seen, tl.created_at "
                + "FROM team_leader tl JOIN department d ON tl.department_id = d.department_id WHERE tl.status='Pending' "
                + "UNION "
                + "SELECT e.employee_id AS id, 'Employee' AS role, e.name, e.email, d.department_name AS department, e.status, e.is_seen, e.created_at "
                + "FROM employee e JOIN department d ON e.dept_id = d.department_id WHERE e.status='Pending' "
                + "ORDER BY created_at DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PendingRegistration reg = new PendingRegistration(
                    rs.getInt("id"),
                    rs.getString("role"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("department"),
                    rs.getString("status"),
                    rs.getBoolean("is_seen")
                );
                registrations.add(reg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return registrations;
    }

    public boolean hasUnseenRegistrations() {
        boolean hasUnseen = false;
        Connection con = DbConnection.getConnection();
        try {
            PreparedStatement ps = con.prepareStatement(
                "SELECT COUNT(*) FROM team_leader WHERE status = 'Pending' AND is_seen = FALSE "
                + "UNION ALL "
                + "SELECT COUNT(*) FROM employee WHERE status = 'Pending' AND is_seen = FALSE");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                if (rs.getInt(1) > 0) {
                    hasUnseen = true;
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return hasUnseen;
    }

    public void markAsSeen() {
        Connection con = DbConnection.getConnection();
        try {
            PreparedStatement ps1 = con.prepareStatement("UPDATE team_leader SET is_seen = TRUE WHERE status='Pending'");
            ps1.executeUpdate();
            PreparedStatement ps2 = con.prepareStatement("UPDATE employee SET is_seen = TRUE WHERE status='Pending'");
            ps2.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}