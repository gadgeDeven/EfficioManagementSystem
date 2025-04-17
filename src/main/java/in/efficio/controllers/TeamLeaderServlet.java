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
        String from = request.getParameter("from"); // Track origin
        request.setAttribute("contentType", "view-teamleaders");

        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Optional<TeamLeader> tlOptional = teamLeaderDAO.getTeamLeaderById(id);
                if (tlOptional.isPresent()) {
                    request.setAttribute("teamLeader", tlOptional.get());
                    request.setAttribute("from", from); // Pass origin to JSP
                    request.getRequestDispatcher("views/dashboards/admin/admin-dashboard.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Team Leader not found.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid Team Leader ID.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
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