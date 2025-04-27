package in.efficio.dao;

import in.efficio.dbconnection.DbConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FeedbackDAO {
    private static final Logger LOGGER = Logger.getLogger(FeedbackDAO.class.getName());

    public int getUnseenFeedbackCount(int employeeId) {
        String query = "SELECT COUNT(*) FROM feedback WHERE employee_id = ? AND is_seen = FALSE";
        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting unseen feedback for employee: " + employeeId, e);
        }
        return 0;
    }
}