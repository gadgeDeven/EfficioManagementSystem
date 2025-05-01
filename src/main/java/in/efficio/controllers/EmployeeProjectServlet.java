package in.efficio.controllers;

import in.efficio.dao.EmployeeDAO;
import in.efficio.dao.ProjectDAO;
import in.efficio.model.Employee;
import in.efficio.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/EmployeeProjectServlet")
public class EmployeeProjectServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EmployeeProjectServlet.class.getName());
    private ProjectDAO projectDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        projectDAO = new ProjectDAO();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        int employeeId = (Integer) session.getAttribute("employeeId");
        String contentType = request.getParameter("contentType");
        String action = request.getParameter("action");
        String projectIdStr = request.getParameter("projectId");

        if (contentType == null) {
            contentType = "projects";
        }

        // Fetch projects assigned to the employee
        List<Project> projects = projectDAO.getProjectsByEmployee(employeeId);
        request.setAttribute("projects", projects);

        // Handle project view action
        if ("view".equals(action) && projectIdStr != null && !projectIdStr.isEmpty()) {
            try {
                int projectId = Integer.parseInt(projectIdStr);
                Project project = projectDAO.getProjectById(projectId);
                if (project == null || !projects.stream().anyMatch(p -> p.getProjectId() == projectId)) {
                    request.setAttribute("errorMessage", "Project not found or not assigned to you.");
                } else {
                    Integer progress = projectDAO.getProjectProgress(projectId);
                    List<Employee> assignedEmployees = employeeDAO.getEmployeesByProject(projectId);
                    request.setAttribute("projectDetails", project);
                    request.setAttribute("progress", progress);
                    request.setAttribute("assignedEmployees", assignedEmployees);
                    request.setAttribute("action", "view");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid project ID.");
                LOGGER.severe("Invalid project ID: " + e.getMessage());
            }
        }

        // Set include path
        request.setAttribute("contentType", contentType);
        request.setAttribute("includePath", "projects.jsp");
        request.getRequestDispatcher("/views/dashboards/employee/EmployeeDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}