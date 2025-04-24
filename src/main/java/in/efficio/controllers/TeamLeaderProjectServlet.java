package in.efficio.controllers;

import in.efficio.dao.ProjectDAO;
import in.efficio.model.Project;
import in.efficio.model.TeamLeader;
import in.efficio.model.Employee;
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
        String action = request.getParameter("action");
        String projectIdStr = request.getParameter("projectId");
        String from = request.getParameter("from");
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

        // Handle project view action
        if ("view".equals(action) && projectIdStr != null && !projectIdStr.isEmpty()) {
            try {
                int projectId = Integer.parseInt(projectIdStr);
                selectedProject = projectDAO.getProjectById(projectId);
                if (selectedProject == null || !projects.stream().anyMatch(p -> p.getProjectId() == projectId)) {
                    request.setAttribute("errorMessage",
                            (contentType.equals("pending-projects") ? "Pending" :
                             contentType.equals("completed-projects") ? "Completed" : "") +
                            " project not found or not assigned to you.");
                    request.setAttribute("projects", projects);
                    request.setAttribute("contentType", contentType);
                    request.setAttribute("includePath", contentType + ".jsp");
                    request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
                    return;
                } else {
                    // Fetch additional details for the project
                    Integer progress = projectDAO.getProjectProgress(projectId);
                    List<TeamLeader> teamLeaders = projectDAO.getAssignedTeamLeaders(projectId);
                    List<Employee> employees = projectDAO.getEmployeesByProjectId(projectId);

                    request.setAttribute("projectDetails", selectedProject);
                    request.setAttribute("teamLeaders", teamLeaders);
                    request.setAttribute("employees", employees);
                    request.setAttribute("progress", progress);
                    request.setAttribute("from", from);
                    request.setAttribute("contentType", contentType);
                    request.setAttribute("action", "view");
                    request.setAttribute("includePath", "projects.jsp");
                    request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid project ID.");
            }
        }

        // Default: Show project list
        request.setAttribute("projects", projects);
        request.setAttribute("selectedProject", selectedProject);
        request.setAttribute("contentType", contentType);
        request.setAttribute("includePath", contentType + ".jsp");
        request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
    }
}