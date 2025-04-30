package in.efficio.controllers;

import in.efficio.dao.ProjectDAO;
import in.efficio.dao.TaskDAO;
import in.efficio.model.Project;
import in.efficio.model.Task;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/EmployeeCalendarServlet")
public class EmployeeCalendarServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EmployeeCalendarServlet.class.getName());
    private TaskDAO taskDAO;
    private ProjectDAO projectDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
        projectDAO = new ProjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        Integer employeeId = (Integer) session.getAttribute("employeeId");
        if (employeeId == null) {
            employeeId = (Integer) session.getAttribute("userId");
            if (employeeId == null) {
                response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Invalid session: Employee ID missing.");
                return;
            }
            session.setAttribute("employeeId", employeeId);
        }

        try {
            // Fetch tasks and projects
            List<Task> tasks = taskDAO.getTasksByEmployeeId(employeeId);
            List<Project> projects = projectDAO.getProjectsByEmployee(employeeId);

            // Set attributes for JSP
            request.setAttribute("tasks", tasks);
            request.setAttribute("projects", projects);
            request.setAttribute("contentType", "calendar");
            request.setAttribute("includePath", "calendar.jsp");

            // Debug log
            LOGGER.info("EmployeeCalendarServlet: Forwarding to EmployeeDashboard.jsp with tasks=" + (tasks != null ? tasks.size() : 0) +
                        ", projects=" + (projects != null ? projects.size() : 0));

            // Forward to EmployeeDashboard.jsp
            request.getRequestDispatcher("/views/dashboards/employee/EmployeeDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error in EmployeeCalendarServlet: " + e.getMessage());
            request.setAttribute("errorMessage", "Something went wrong while loading the calendar.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}