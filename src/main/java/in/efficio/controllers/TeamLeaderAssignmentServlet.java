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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/TeamLeaderAssignmentServlet")
public class TeamLeaderAssignmentServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;
    private ProjectDAO projectDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
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

        List<Project> projects = projectDAO.getProjects(teamLeaderId);
        Project selectedProject = null;
        List<Employee> allEmployees = employeeDAO.getAllEmployees();
        List<Employee> assignedEmployees = new ArrayList<>();
        String projectIdStr = request.getParameter("projectId");

        if (projectIdStr != null && !projectIdStr.isEmpty()) {
            try {
                int projectId = Integer.parseInt(projectIdStr);
                selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst().orElse(null);
                if (selectedProject == null) {
                    request.setAttribute("errorMessage", "Selected project is not assigned to you.");
                } else {
                    assignedEmployees = employeeDAO.getEmployeesByProject(projectId);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid project ID.");
            }
        }

        request.setAttribute("projects", projects);
        request.setAttribute("selectedProject", selectedProject);
        request.setAttribute("allEmployees", allEmployees);
        request.setAttribute("assignedEmployees", assignedEmployees);
        request.setAttribute("includePath", "assign-projects.jsp");
        request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        String action = request.getParameter("action");

        if ("assignEmployee".equals(action)) {
            String projectIdStr = request.getParameter("projectId");
            String employeeIdStr = request.getParameter("employeeId");
            String assignAction = request.getParameter("assign");
            try {
                int projectId = Integer.parseInt(projectIdStr);
                int employeeId = Integer.parseInt(employeeIdStr);
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                Project selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst()
                        .orElse(null);
                if (selectedProject == null) {
                    request.setAttribute("errorMessage", "Selected project is not assigned to you.");
                } else {
                    if ("add".equals(assignAction)) {
                        employeeDAO.assignEmployeeToProject(employeeId, projectId, teamLeaderId);
                        request.setAttribute("successMessage",
                                "Employee assigned successfully to project: " + selectedProject.getProjectName());
                    } else if ("remove".equals(assignAction)) {
                        employeeDAO.removeEmployeeFromProject(employeeId, projectId);
                        request.setAttribute("successMessage",
                                "Employee removed successfully from project: " + selectedProject.getProjectName());
                    }
                }
                List<Employee> allEmployees = employeeDAO.getAllEmployees();
                List<Employee> assignedEmployees = employeeDAO.getEmployeesByProject(projectId);
                request.setAttribute("projects", projects);
                request.setAttribute("selectedProject", selectedProject);
                request.setAttribute("allEmployees", allEmployees);
                request.setAttribute("assignedEmployees", assignedEmployees);
                request.setAttribute("includePath", "assign-projects.jsp");
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid project or employee ID.");
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                request.setAttribute("projects", projects);
                request.setAttribute("includePath", "assign-projects.jsp");
            } catch (RuntimeException e) {
                request.setAttribute("errorMessage", "Failed to process assignment: " + e.getMessage());
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                request.setAttribute("projects", projects);
                request.setAttribute("includePath", "assign-projects.jsp");
            }
        } else if ("manageEmployees".equals(action)) {
            String projectIdStr = request.getParameter("projectId");
            String[] employeeIds = request.getParameterValues("employeeIds");
            try {
                int projectId = Integer.parseInt(projectIdStr);
                List<Integer> selectedEmployeeIds = new ArrayList<>();
                if (employeeIds != null) {
                    for (String id : employeeIds) {
                        selectedEmployeeIds.add(Integer.parseInt(id));
                    }
                }
                employeeDAO.updateEmployeeAssignments(projectId, teamLeaderId, selectedEmployeeIds);
                request.setAttribute("successMessage", "Employee assignments updated successfully.");
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                Project selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst()
                        .orElse(null);
                List<Employee> allEmployees = employeeDAO.getAllEmployees();
                List<Employee> assignedEmployees = employeeDAO.getEmployeesByProject(projectId);
                request.setAttribute("projects", projects);
                request.setAttribute("selectedProject", selectedProject);
                request.setAttribute("allEmployees", allEmployees);
                request.setAttribute("assignedEmployees", assignedEmployees);
                request.setAttribute("includePath", "assign-projects.jsp");
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid project or employee IDs.");
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                request.setAttribute("projects", projects);
                request.setAttribute("includePath", "assign-projects.jsp");
            } catch (RuntimeException e) {
                request.setAttribute("errorMessage", "Failed to update assignments: " + e.getMessage());
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                request.setAttribute("projects", projects);
                request.setAttribute("includePath", "assign-projects.jsp");
            }
        }

        request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
    }
}