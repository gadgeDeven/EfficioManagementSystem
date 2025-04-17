package in.efficio.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import in.efficio.dbconnection.DbConnection;

@WebServlet("/ApproveRejectServlet")
public class ApproveRejectServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (request.getSession().getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        String id = request.getParameter("id");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        Connection con = null;
        try {
            con = DbConnection.getConnection();
            String table = "Team Leader".equals(role) ? "team_leader" : "employee";
            String idColumn = "Team Leader".equals(role) ? "teamleader_id" : "employee_id";
            PreparedStatement ps = con.prepareStatement(
                "UPDATE " + table + " SET status = ? WHERE " + idColumn + " = ?");
            ps.setString(1, status);
            ps.setInt(2, Integer.parseInt(id));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Redirect back to dashboard without changing contentType
        response.sendRedirect(request.getContextPath() + "/DashboardServlet?contentType=welcome");
    }
}