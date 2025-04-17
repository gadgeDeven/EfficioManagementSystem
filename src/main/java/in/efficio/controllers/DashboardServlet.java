package in.efficio.controllers;

import in.efficio.dao.DashboardDAO;
import in.efficio.dao.ProjectDAO;
import in.efficio.model.DashboardStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import in.efficio.model.Project;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private DashboardDAO dashboardDAO;
    private ProjectDAO projectDAO;

    public DashboardServlet() {
        this.dashboardDAO = new DashboardDAO();
        this.projectDAO = new ProjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            if (request.getSession().getAttribute("userName") == null) {
                response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
                return;
            }

            String contentType = request.getParameter("contentType");
            if (contentType == null) contentType = "welcome";

            // Fetch fresh stats
            DashboardStats stats = dashboardDAO.getDashboardStats();
            request.getSession().setAttribute("stats", stats);
            request.setAttribute("stats", stats);

            // Handle dashboard-specific content
            if ("adminsList".equals(contentType)) {
                // Placeholder for admin list
            } else if ("projectsList".equals(contentType)) {
                List<Project> projects = projectDAO.getAllProjects();
                request.setAttribute("projects", projects);
            } else if ("pendingList".equals(contentType)) {
                List<Project> projects = projectDAO.getProjectsByStatus("Ongoing");
                request.setAttribute("projects", projects);
            } else if ("completedList".equals(contentType)) {
                List<Project> projects = projectDAO.getProjectsByStatus("Completed");
                request.setAttribute("projects", projects);
            } else if ("productivityList".equals(contentType)) {
                // Stats already set
            }

            request.setAttribute("notificationCount", 0); // Placeholder
            request.setAttribute("contentType", contentType);
            request.getRequestDispatcher("/views/dashboards/admin/admin-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Something went wrong while loading the dashboard.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}