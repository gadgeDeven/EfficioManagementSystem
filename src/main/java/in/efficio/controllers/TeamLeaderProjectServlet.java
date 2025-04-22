package in.efficio.controllers;

import in.efficio.dao.ProjectDAO;
import in.efficio.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/TeamLeaderProjectServlet")
public class TeamLeaderProjectServlet extends HttpServlet {
    private ProjectDAO projectDAO;

    @Override
    public void init() {
        projectDAO = new ProjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        String teamLeaderEmail = (String) session.getAttribute("userName");
        int teamLeaderId = projectDAO.getTeamLeaderIdByEmail(teamLeaderEmail);
        if (teamLeaderId == -1) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Invalid Team Leader.");
            return;
        }

        String contentType = request.getParameter("contentType");
        String projectIdStr = request.getParameter("projectId");
        List<Project> projects;
        Project selectedProject = null;

        // Determine projects based on content type
        if ("pending-projects".equals(contentType)) {
            projects = projectDAO.getProjectsByStatusTeam(teamLeaderId, "Ongoing");
        } else if ("completed-projects".equals(contentType)) {
            projects = projectDAO.getProjectsByStatusTeam(teamLeaderId, "Completed");
        } else {
            projects = projectDAO.getProjects(teamLeaderId);
        }

        // Handle project selection
        if (projectIdStr != null && !projectIdStr.isEmpty()) {
            try {
                int projectId = Integer.parseInt(projectIdStr);
                selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst().orElse(null);
                if (selectedProject == null) {
                    request.setAttribute("errorMessage",
                            (contentType.equals("pending-projects") ? "Pending" :
                             contentType.equals("completed-projects") ? "Completed" : "") +
                            " project not found or not assigned to you.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid project ID.");
            }
        }

        request.setAttribute("projects", projects);
        request.setAttribute("selectedProject", selectedProject);
        request.setAttribute("includePath", "projects.jsp");
        request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
    }
}