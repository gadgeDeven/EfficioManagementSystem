package in.efficio.controllers;

import in.efficio.dao.DashboardDAO;
import in.efficio.model.DashboardStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/EmployeeDashboardServlet")
public class EmployeeDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EmployeeDashboardServlet.class.getName());
    private DashboardDAO dashboardDAO;

    @Override
    public void init() {
        dashboardDAO = new DashboardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            LOGGER.warning("No session or userName for request to EmployeeDashboardServlet, session ID: " + 
                           (session != null ? session.getId() : "null"));
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        // Debug session attributes
        LOGGER.info("Session ID in EmployeeDashboardServlet: " + session.getId());
        session.getAttributeNames().asIterator().forEachRemaining(name ->
            LOGGER.info("Session attribute: " + name + " = " + session.getAttribute(name)));

        // Check for employeeId
        Integer employeeId = (Integer) session.getAttribute("employeeId");
        if (employeeId == null) {
            // Fallback: Try userId
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                employeeId = userId;
                session.setAttribute("employeeId", employeeId);
                LOGGER.info("Recovered employeeId from userId: " + employeeId);
            } else {
                LOGGER.severe("employeeId and userId are null for user: " + session.getAttribute("userName"));
                response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Invalid session: Employee ID missing.");
                return;
            }
        }

        // Prepare DashboardStats
        DashboardStats stats = new DashboardStats();
        updateStats(stats, employeeId);
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
            request.getRequestDispatcher("/views/dashboards/employee/EmployeeDashboard.jsp").forward(request, response);
        } else {
            // Forward to appropriate servlet based on content type
            String forwardPath;
            switch (contentType) {
                case "projects":
                    forwardPath = "/EmployeeProjectServlet";
                    break;
                case "tasks":
                    forwardPath = "/EmployeeTaskServlet";
                    break;
                case "calendar":
                    forwardPath = "/EmployeeCalendarServlet";
                    break;
                case "progress-update":
                    forwardPath = "/EmployeeProgressServlet";
                    break;
                case "team-members":
                    forwardPath = "/EmployeeTeamServlet";
                    break;
                case "feedback":
                    forwardPath = "/EmployeeFeedbackServlet";
                    break;
                case "profile":
                    forwardPath = "/EmployeeProfileServlet";
                    break;
                default:
                    forwardPath = "/EmployeeWelcomeServlet";
            }
            LOGGER.info("Forwarding to: " + forwardPath + " with contentType: " + contentType);
            request.getRequestDispatcher(forwardPath).forward(request, response);
        }
    }

    private void updateStats(DashboardStats stats, int employeeId) {
        stats.setProjectCount(dashboardDAO.getEmployeeProjectCount(employeeId));
        stats.setTaskCount(dashboardDAO.getEmployeeTaskCount(employeeId));
        stats.setPendingTaskCount(dashboardDAO.getEmployeePendingTaskCount(employeeId));
        stats.setCompletedTaskCount(dashboardDAO.getEmployeeCompletedTaskCount(employeeId));
        int totalTasks = stats.getPendingTaskCount() + stats.getCompletedTaskCount();
        stats.setProductivity(totalTasks > 0 ? (stats.getCompletedTaskCount() * 100.0) / totalTasks : 0);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}