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
        LOGGER.info("Initializing TeamLeaderDashboard");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            LOGGER.warning("Session is null or userName is not set, redirecting to LogoutServlet");
            response.sendRedirect(
                    request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        String teamLeaderEmail = (String) session.getAttribute("userName");
        Integer teamLeaderId = (Integer) session.getAttribute("teamLeaderId");
        if (teamLeaderId == null) {
            teamLeaderId = projectDAO.getTeamLeaderIdByEmail(teamLeaderEmail);
            if (teamLeaderId == -1) {
                LOGGER.severe("Invalid team leader for email: " + teamLeaderEmail);
                response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Invalid Team Leader.");
                return;
            }
            session.setAttribute("teamLeaderId", teamLeaderId);
            LOGGER.info("Set teamLeaderId: " + teamLeaderId + " for user: " + teamLeaderEmail);
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
        String includePath = null;
        String forwardPath = null;
        switch (contentType) {
            case "welcome":
                includePath = "/views/dashboards/team-leader/welcome.jsp";
                break;
            case "profile":
                forwardPath = "/TeamLeaderProfileServlet";
                break;
            case "productivity":
                includePath = "/views/dashboards/team-leader/productivity.jsp";
                break;
            case "notifications":
                includePath = "/views/dashboards/team-leader/notifications.jsp";
                break;
            case "settings":
                forwardPath = "/TeamLeaderProfileServlet";
                break;
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
                LOGGER.warning("Unknown contentType: " + contentType + ", defaulting to welcome");
                includePath = "/views/dashboards/team-leader/welcome.jsp";
                contentType = "welcome";
                request.setAttribute("contentType", contentType);
                break;
        }

        if (forwardPath != null) {
            LOGGER.info("Forwarding to: " + forwardPath + " with contentType: " + contentType);
            request.getRequestDispatcher(forwardPath).forward(request, response);
        } else {
            // Verify includePath exists
            if (getServletContext().getResource(includePath) == null) {
                LOGGER.severe("Include path not found: " + includePath);
                request.setAttribute("message", "Error: Dashboard content not found");
                request.setAttribute("alertType", "error");
                includePath = "/views/dashboards/common/error.jsp";
            }
            request.setAttribute("includePath", includePath);
            LOGGER.info("Forwarding to TeamLeaderDashboard.jsp with includePath: " + includePath);
            request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
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