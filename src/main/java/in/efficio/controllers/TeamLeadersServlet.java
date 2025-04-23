package in.efficio.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import in.efficio.model.TeamLeader;
import in.efficio.dao.TeamLeaderDAO; // Assume this exists
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/TeamLeaders")
public class TeamLeadersServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        String contentType = request.getParameter("contentType");
        TeamLeaderDAO teamLeaderDAO = new TeamLeaderDAO(); // Assume DAO for team leader data

        if ("view-teamleaders".equals(contentType)) {
            // Fetch list of team leaders
            List<TeamLeader> teamLeaders = teamLeaderDAO.getAllTeamLeaders();
            Integer teamLeaderCount = teamLeaders != null ? teamLeaders.size() : 0;
            request.setAttribute("teamLeaders", teamLeaders);
            request.setAttribute("teamLeaderCount", teamLeaderCount);
            request.setAttribute("contentType", contentType);
            // Forward to admin-dashboard.jsp instead of teamleader_list.jsp
            request.getRequestDispatcher("/views/dashboards/admin/admin-dashboard.jsp").forward(request, response);
        } else if ("teamleader-profile".equals(contentType)) {
            String id = request.getParameter("id");
            String projectId = request.getParameter("projectId");
            String from = request.getParameter("from");
            Optional<TeamLeader> teamLeaderOptional = teamLeaderDAO.getTeamLeaderById(Integer.parseInt(id));
            TeamLeader teamLeader = teamLeaderOptional.orElse(null); // Extract TeamLeader or null
            request.setAttribute("teamLeader", teamLeader);
            request.setAttribute("projectId", projectId);
            request.setAttribute("from", from);
            request.getRequestDispatcher("/views/dashboards/admin/admin-dashboard.jsp").forward(request, response);
        } else {
            // Default or error handling
            response.sendRedirect(request.getContextPath() + "/DashboardServlet?contentType=welcome");
        }
    }
}