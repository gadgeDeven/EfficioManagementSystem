
package in.efficio.controllers;

import in.efficio.dao.EmployeeDAO;
import in.efficio.dao.ProjectDAO;
import in.efficio.dao.TaskDAO;
import in.efficio.model.DashboardStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/TeamLeaderDashboard")
public class TeamLeaderDashboard extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TeamLeaderDashboard.class.getName());
    private EmployeeDAO employeeDAO;
    private ProjectDAO projectDAO;
    private TaskDAO taskDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        projectDAO = new ProjectDAO();
        taskDAO = new TaskDAO();
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

        // Prepare DashboardStats
        DashboardStats stats = new DashboardStats();
        updateStats(stats, teamLeaderId);
        request.setAttribute("stats", stats);

        String contentType = request.getParameter("contentType");
        if (contentType == null) {
            contentType = "welcome";
        }
        request.setAttribute("contentType", contentType);

        // Handle dashboard-related content types
        if ("welcome".equals(contentType) || "productivity".equals(contentType) || "notifications".equals(contentType)) {
            request.setAttribute("includePath", "welcome".equals(contentType) ? "welcome.jsp" : 
                                               "productivity".equals(contentType) ? "productivity.jsp" : "notifications.jsp");
            request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
        } else {
            // Forward to appropriate servlet based on content type
            String forwardPath;
            switch (contentType) {
                case "projects":
                case "pending-projects":
                case "completed-projects":
                    forwardPath = "/TeamLeaderProjectServlet";
                    break;
                case "tasks":
                case "pending-tasks":
                case "completed-tasks":
                case "create-task":
                case "tasks-by-project":
                case "assign-task":
                    forwardPath = "/TeamLeaderTaskServlet";
                    break;
                case "assign-projects":
                    forwardPath = "/TeamLeaderAssignmentServlet";
                    break;
                case "team-members":
                case "employee-details":
                    forwardPath = "/TeamLeaderTeamServlet";
                    break;
                default:
                    forwardPath = "/TeamLeaderWelcome";
            }
            LOGGER.info("Forwarding to: " + forwardPath + " with contentType: " + contentType);
            request.getRequestDispatcher(forwardPath).forward(request, response);
        }
    }

    private void updateStats(DashboardStats stats, int teamLeaderId) {
        stats.setTeamSize(employeeDAO.getTeamSize(String.valueOf(teamLeaderId)));
        stats.setProjectCount(projectDAO.getProjectCount(teamLeaderId));
        stats.setPendingProjectCount(projectDAO.getProjectsByStatusTeam(teamLeaderId, "Ongoing").size());
        stats.setCompletedProjectCount(projectDAO.getProjectsByStatusTeam(teamLeaderId, "Completed").size());
        stats.setTaskCount(taskDAO.getTaskCount(teamLeaderId));
        stats.setPendingTaskCount(taskDAO.getPendingTaskCount(teamLeaderId));
        stats.setCompletedTaskCount(taskDAO.getCompletedTaskCount(teamLeaderId));
        int totalTasks = stats.getPendingTaskCount() + stats.getCompletedTaskCount();
        stats.setProductivity(totalTasks > 0 ? (stats.getCompletedTaskCount() * 100.0) / totalTasks : 0);
    }
}
