package in.efficio.controllers;

import in.efficio.dao.EmployeeDAO;
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
import java.util.Optional;
import java.util.logging.Logger;

@WebServlet("/TeamLeaderProjectServlet")
public class TeamLeaderProjectServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TeamLeaderProjectServlet.class.getName());
    private ProjectDAO projectDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        projectDAO = new ProjectDAO();
        employeeDAO = new EmployeeDAO(); // Initialize employeeDAO to resolve the error
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
        } else if ("assign-projects".equals(contentType)) {
            projects = projectDAO.getProjects(teamLeaderId);
            request.setAttribute("allEmployees", employeeDAO.getAllEmployees()); // Fetch all employees
            if (projectIdStr != null && !projectIdStr.isEmpty()) {
                try {
                    int projectId = Integer.parseInt(projectIdStr);
                    selectedProject = projectDAO.getProjectById(projectId);
                    if (selectedProject == null || !projects.stream().anyMatch(p -> p.getProjectId() == projectId)) {
                        request.setAttribute("errorMessage", "Project not found or not assigned to you.");
                    } else {
                        request.setAttribute("selectedProject", selectedProject);
                        request.setAttribute("assignedEmployees", employeeDAO.getEmployeesByProject(projectId)); // Use EmployeeDAO
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid project ID.");
                    LOGGER.severe("Invalid project ID: " + e.getMessage());
                }
            }
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
                            (contentType != null && contentType.equals("pending-projects") ? "Pending" :
                             contentType != null && contentType.equals("completed-projects") ? "Completed" : "") +
                            " project not found or not assigned to you.");
                } else {
                    // Fetch additional details for the project
                    Integer progress = projectDAO.getProjectProgress(projectId);
                    List<TeamLeader> teamLeaders = projectDAO.getAssignedTeamLeaders(projectId);
                    List<Employee> employees = employeeDAO.getEmployeesByProject(projectId); // Use EmployeeDAO instead of ProjectDAO

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
                LOGGER.severe("Invalid project ID in view action: " + e.getMessage());
            }
        }
        if ("employee-details".equals(contentType)) {
            try {
                int employeeId = Integer.parseInt(request.getParameter("employeeId"));
                Optional<Employee> employee = employeeDAO.getEmployeeById(employeeId);
                if (employee.isPresent()) {
                    request.setAttribute("employee", employee.get());
                    request.setAttribute("includePath", "employee-details.jsp");
                } else {
                    request.setAttribute("errorMessage", "Employee not found.");
                    request.setAttribute("includePath", "error.jsp");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid employee ID.");
                request.setAttribute("includePath", "error.jsp");
            }
            request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
            return;
        }
        
     // In TeamLeaderProjectServlet.java
        if ("project-details".equals(contentType)) {
            String projectIdStr1 = request.getParameter("projectId");
            LOGGER.info("Received projectId: " + projectIdStr1);
            if (projectIdStr1 != null && !projectIdStr1.isEmpty()) {
                try {
                    int projectId = Integer.parseInt(projectIdStr1);
                    Project project = projectDAO.getProjectById(projectId);
                    if (project != null) {
                        request.setAttribute("selectedProject", project);
                        request.setAttribute("from", request.getParameter("from"));
                        request.setAttribute("employeeId", request.getParameter("employeeId"));
                        request.getRequestDispatcher("/views/dashboards/team-leader/project-details.jsp").forward(request, response);
                    } else {
                        request.setAttribute("errorMessage", "Project not found.");
                        request.getRequestDispatcher("/views/dashboards/team-leader/team-members.jsp").forward(request, response);
                    }
                } catch (NumberFormatException e) {
                    LOGGER.severe("Invalid project ID: " + projectIdStr1);
                    request.setAttribute("errorMessage", "Invalid project ID.");
                    request.getRequestDispatcher("/views/dashboards/team-leader/team-members.jsp").forward(request, response);
                }
            } else {
                LOGGER.severe("No project ID provided.");
                request.setAttribute("errorMessage", "No project selected.");
                request.getRequestDispatcher("/views/dashboards/team-leader/team-members.jsp").forward(request, response);
            }
        }

        // Default: Show project list or assign-projects page
        request.setAttribute("projects", projects);
        request.setAttribute("selectedProject", selectedProject);
        request.setAttribute("contentType", contentType);
        request.setAttribute("includePath", contentType + ".jsp");
        request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        String teamLeaderEmail = (String) session.getAttribute("userName");
        int teamLeaderId = projectDAO.getTeamLeaderIdByEmail(teamLeaderEmail);
        if (teamLeaderId == -1) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Invalid Team Leader.");
            return;
        }

        String action = request.getParameter("action");
        if ("assignEmployee".equals(action)) {
            String projectIdStr = request.getParameter("projectId");
            String employeeIdStr = request.getParameter("employeeId");
            String assignAction = request.getParameter("assign");

            try {
                int projectId = Integer.parseInt(projectIdStr);
                int employeeId = Integer.parseInt(employeeIdStr);

                // Verify project is assigned to the team leader
                List<Project> teamLeaderProjects = projectDAO.getProjects(teamLeaderId);
                if (!teamLeaderProjects.stream().anyMatch(p -> p.getProjectId() == projectId)) {
                    request.setAttribute("errorMessage", "You are not authorized to assign employees to this project.");
                } else if ("add".equals(assignAction)) {
                    employeeDAO.assignEmployeeToProject(employeeId, projectId, teamLeaderId);
                    request.setAttribute("successMessage", "Employee assigned successfully.");
                } else if ("remove".equals(assignAction)) {
                    employeeDAO.removeEmployeeFromProject(employeeId, projectId);
                    request.setAttribute("successMessage", "Employee removed successfully.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid project or employee ID.");
                LOGGER.severe("Invalid project or employee ID: " + e.getMessage());
            } catch (RuntimeException e) {
                request.setAttribute("errorMessage", e.getMessage());
                LOGGER.severe("Error processing employee assignment: " + e.getMessage());
            }
        } else {
            request.setAttribute("errorMessage", "Invalid action.");
            LOGGER.warning("Invalid action received: " + action);
        }

        // Redirect back to assign-projects page with the same project selected
        String projectId = request.getParameter("projectId");
        response.sendRedirect(request.getContextPath() + "/TeamLeaderProjectServlet?contentType=assign-projects&projectId=" + projectId);
    }
}