package in.efficio.controllers;

import in.efficio.dao.EmployeeDAO;
import in.efficio.dao.ProjectDAO;
import in.efficio.dao.TaskDAO;
import in.efficio.model.DashboardStats;
import in.efficio.model.Employee;
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
import java.util.Optional;
import java.util.logging.Logger;

@WebServlet("/TeamLeaderTeamServlet")
public class TeamLeaderTeamServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TeamLeaderTeamServlet.class.getName());
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
        String displayName = (String) session.getAttribute("displayName");
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
            contentType = "team-members";
        }
        request.setAttribute("contentType", contentType);

        String includePath;
        if ("team-members".equals(contentType)) {
            List<Employee> teamMembers = employeeDAO.getTeamMembers(displayName);
            // Fetch tasks for each team member
            for (Employee employee : teamMembers) {
                List<Task> tasks = employeeDAO.getTasksForEmployee(employee.getEmployee_id());
                employee.setTasks(tasks);
            }
            request.setAttribute("teamMembers", teamMembers);
            request.setAttribute("teamMemberCount", teamMembers.size());
            includePath = "team-members.jsp";
        } else if ("employee-details".equals(contentType)) {
            String employeeIdStr = request.getParameter("employeeId");
            if (employeeIdStr != null && !employeeIdStr.isEmpty()) {
                try {
                    int employeeId = Integer.parseInt(employeeIdStr);
                    Optional<Employee> employeeOpt = employeeDAO.getEmployeeById(employeeId);
                    if (employeeOpt.isPresent()) {
                        Employee employee = employeeOpt.get();
                        // Fetch tasks for the employee
                        List<Task> tasks = employeeDAO.getTasksForEmployee(employeeId);
                        // Fetch projects for the employee
                        List<Project> projects = employeeDAO.getProjectsForEmployee(employeeId);
                        employee.setTasks(tasks);
                        employee.setProjects(projects);
                        request.setAttribute("employee", employee);
                        request.setAttribute("currentTeamLeaderId", teamLeaderId); // Pass current team leader ID
                        request.setAttribute("from", request.getParameter("from"));
                        request.setAttribute("projectId", request.getParameter("projectId"));
                        includePath = "employee-details.jsp";
                    } else {
                        request.setAttribute("errorMessage", "Employee not found.");
                        includePath = "team-members.jsp";
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid employee ID.");
                    includePath = "team-members.jsp";
                }
            } else {
                request.setAttribute("errorMessage", "No employee selected.");
                includePath = "team-members.jsp";
            }
        } else {
            includePath = "team-members.jsp";
        }

        LOGGER.info("Forwarding to TeamLeaderDashboard.jsp with includePath: " + includePath + ", contentType: " + contentType);
        request.setAttribute("includePath", includePath);
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

        // Prepare DashboardStats
        DashboardStats stats = new DashboardStats();
        updateStats(stats, teamLeaderId);
        request.setAttribute("stats", stats);

        String includePath = "team-members.jsp";
        request.setAttribute("includePath", includePath);
        request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
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