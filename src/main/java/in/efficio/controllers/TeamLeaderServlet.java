package in.efficio.controllers;

import in.efficio.dao.TeamLeaderDAO;
import in.efficio.model.TeamLeader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/TeamLeaders")
public class TeamLeaderServlet extends HttpServlet {
    private TeamLeaderDAO teamLeaderDAO;

    @Override
    public void init() {
        teamLeaderDAO = new TeamLeaderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        String idParam = request.getParameter("id");
        String from = request.getParameter("from");
        String contentType = request.getParameter("contentType");
        request.setAttribute("contentType", contentType != null ? contentType : "view-teamleaders");
        request.setAttribute("from", from);

        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Optional<TeamLeader> tlOptional = teamLeaderDAO.getTeamLeaderById(id);
                if (tlOptional.isPresent()) {
                    request.setAttribute("teamLeader", tlOptional.get());
                    request.setAttribute("projectId", request.getParameter("projectId"));
                    request.getRequestDispatcher("views/dashboards/admin/admin-dashboard.jsp").forward(request, response);
                } else {
                    session.setAttribute("error", "Team Leader not found.");
                    response.sendRedirect(request.getContextPath() + "/Projects?contentType=project-team-leaders&projectId=" + request.getParameter("projectId"));
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid Team Leader ID.");
                response.sendRedirect(request.getContextPath() + "/Projects?contentType=project-team-leaders&projectId=" + request.getParameter("projectId"));
            }
        } else {
            List<TeamLeader> teamLeaders = teamLeaderDAO.getAllTeamLeaders();
            int teamLeaderCount = teamLeaderDAO.getTeamLeaderCount();
            request.setAttribute("teamLeaders", teamLeaders);
            request.setAttribute("teamLeaderCount", teamLeaderCount);
            request.getRequestDispatcher("views/dashboards/admin/admin-dashboard.jsp").forward(request, response);
        }
    }
}