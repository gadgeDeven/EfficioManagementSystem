package in.efficio.controllers;

import in.efficio.dao.EmployeeDAO;
import in.efficio.dao.ProjectDAO;
import in.efficio.dao.TaskDAO;
import in.efficio.model.DashboardStats;
import in.efficio.model.Employee;
import in.efficio.model.Project;
import in.efficio.model.Task;
import in.efficio.model.TeamLeader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;

@WebServlet("/TeamLeaderTaskServlet")
public class TeamLeaderTaskServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TeamLeaderTaskServlet.class.getName());
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
        String action = request.getParameter("action");
        String taskIdStr = request.getParameter("taskId");
        if (contentType == null) {
            contentType = "tasks";
        }
        request.setAttribute("contentType", contentType);

        // Determine taskFilter based on contentType
        String taskFilter;
        if ("pending-tasks".equals(contentType)) {
            taskFilter = "pending";
        } else if ("completed-tasks".equals(contentType)) {
            taskFilter = "completed";
        } else {
            taskFilter = "all";
        }
        request.setAttribute("taskFilter", taskFilter);

        String includePath;
        if ("view".equals(action) && taskIdStr != null && !taskIdStr.isEmpty()) {
            try {
                int taskId = Integer.parseInt(taskIdStr);
                Task task = taskDAO.getTaskById(taskId);
                if (task == null || task.getAssignByTeamLeaderId() != teamLeaderId) {
                    request.setAttribute("errorMessage", "Task not found or not assigned to you.");
                    if ("pending-tasks".equals(contentType)) {
                        List<Task> pendingTasks = taskDAO.getTasksByStatus(teamLeaderId, "Pending");
                        request.setAttribute("pendingTasks", pendingTasks);
                        LOGGER.info("Pending tasks size: " + (pendingTasks != null ? pendingTasks.size() : "null"));
                        includePath = "tasks.jsp";
                    } else if ("completed-tasks".equals(contentType)) {
                        List<Task> completedTasks = taskDAO.getTasksByStatus(teamLeaderId, "Completed");
                        request.setAttribute("completedTasks", completedTasks);
                        LOGGER.info("Completed tasks size: " + (completedTasks != null ? completedTasks.size() : "null"));
                        includePath = "tasks.jsp";
                    } else {
                        List<Task> tasks = taskDAO.getTasksByTeamLeader(teamLeaderId);
                        List<Project> projects = projectDAO.getProjects(teamLeaderId);
                        request.setAttribute("tasks", tasks);
                        request.setAttribute("projects", projects);
                        LOGGER.info("All tasks size: " + (tasks != null ? tasks.size() : "null"));
                        includePath = "tasks.jsp";
                    }
                    request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
                    return;
                }

                // Fetch additional details
                Project project = projectDAO.getProjectById(task.getProjectId());
                TeamLeader teamLeader = null;
                Employee employee = null;
                if (task.getAssignByTeamLeaderId() != 0) {
                    teamLeader = new TeamLeader();
                    teamLeader.setTeamleader_id(task.getAssignByTeamLeaderId());
                    teamLeader.setName(employeeDAO.getTeamLeaderNameById(task.getAssignByTeamLeaderId()));
                }
                if (task.getAssignedToEmployeeId() != null) {
                    Object employeeResult = employeeDAO.getEmployeeById(task.getAssignedToEmployeeId());
                    if (employeeResult instanceof Optional) {
                        Optional<Employee> optionalEmployee = (Optional<Employee>) employeeResult;
                        employee = optionalEmployee.orElse(null);
                    } else {
                        employee = (Employee) employeeResult;
                    }
                }

                request.setAttribute("taskDetails", task);
                request.setAttribute("project", project);
                request.setAttribute("teamLeader", teamLeader);
                request.setAttribute("employee", employee);
                request.setAttribute("action", "view");
                includePath = "tasks.jsp";
                LOGGER.info("Viewing task ID: " + taskId + " for contentType: " + contentType + ", taskFilter: " + taskFilter);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid task ID.");
                if ("pending-tasks".equals(contentType)) {
                    List<Task> pendingTasks = taskDAO.getTasksByStatus(teamLeaderId, "Pending");
                    request.setAttribute("pendingTasks", pendingTasks);
                    LOGGER.info("Pending tasks size (error case): " + (pendingTasks != null ? pendingTasks.size() : "null"));
                    includePath = "tasks.jsp";
                } else if ("completed-tasks".equals(contentType)) {
                    List<Task> completedTasks = taskDAO.getTasksByStatus(teamLeaderId, "Completed");
                    request.setAttribute("completedTasks", completedTasks);
                    LOGGER.info("Completed tasks size (error case): " + (completedTasks != null ? completedTasks.size() : "null"));
                    includePath = "tasks.jsp";
                } else {
                    List<Task> tasks = taskDAO.getTasksByTeamLeader(teamLeaderId);
                    List<Project> projects = projectDAO.getProjects(teamLeaderId);
                    request.setAttribute("tasks", tasks);
                    request.setAttribute("projects", projects);
                    LOGGER.info("All tasks size (error case): " + (tasks != null ? tasks.size() : "null"));
                    includePath = "tasks.jsp";
                }
            }
        } else if ("tasks".equals(contentType) || "pending-tasks".equals(contentType) || "completed-tasks".equals(contentType)) {
            if ("pending-tasks".equals(contentType)) {
                List<Task> pendingTasks = taskDAO.getTasksByStatus(teamLeaderId, "Pending");
                request.setAttribute("pendingTasks", pendingTasks);
                LOGGER.info("Pending tasks size: " + (pendingTasks != null ? pendingTasks.size() : "null"));
            } else if ("completed-tasks".equals(contentType)) {
                List<Task> completedTasks = taskDAO.getTasksByStatus(teamLeaderId, "Completed");
                request.setAttribute("completedTasks", completedTasks);
                LOGGER.info("Completed tasks size: " + (completedTasks != null ? completedTasks.size() : "null"));
            } else {
                List<Task> tasks = taskDAO.getTasksByTeamLeader(teamLeaderId);
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                List<Employee> teamMembers = employeeDAO.getTeamMembers(displayName);
                request.setAttribute("tasks", tasks);
                request.setAttribute("projects", projects);
                request.setAttribute("teamMembers", teamMembers);
                LOGGER.info("All tasks size: " + (tasks != null ? tasks.size() : "null"));
            }
            includePath = "tasks.jsp";
        } else if ("create-task".equals(contentType)) {
            List<Project> projects = projectDAO.getProjects(teamLeaderId);
            request.setAttribute("projects", projects);
            if (projects == null || projects.isEmpty()) {
                request.setAttribute("errorMessage", "No projects available to create tasks.");
            }
            includePath = "create-task.jsp";
        } else if ("assign-task".equals(contentType)) {
            List<Project> projects = projectDAO.getProjects(teamLeaderId);
            List<Task> tasks = new ArrayList<>();
            List<Employee> teamMembers = new ArrayList<>();
            String selectedProjectId = request.getParameter("projectId");
            if (selectedProjectId != null && !selectedProjectId.isEmpty()) {
                try {
                    int projectId = Integer.parseInt(selectedProjectId);
                    boolean validProject = projects.stream().anyMatch(p -> p.getProjectId() == projectId);
                    if (!validProject) {
                        request.setAttribute("errorMessage", "Selected project is not assigned to you.");
                    } else {
                        tasks = taskDAO.getTasksByProject(projectId, teamLeaderId);
                        teamMembers = employeeDAO.getEmployeesByProject(projectId);
                        if (tasks.isEmpty()) {
                            request.setAttribute("errorMessage", "No tasks found for project ID: " + projectId);
                        }
                        if (teamMembers.isEmpty()) {
                            request.setAttribute("employeeErrorMessage",
                                    "No employees assigned to this project. Please assign employees first.");
                        }
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid project ID.");
                }
            }
            request.setAttribute("projects", projects);
            request.setAttribute("tasks", tasks);
            request.setAttribute("teamMembers", teamMembers);
            request.setAttribute("selectedProjectId", selectedProjectId);
            includePath = "assign-task.jsp";
        } else if ("tasks-by-project".equals(contentType)) {
            String projectIdStr = request.getParameter("projectId");
            Project selectedProject = null;
            List<Task> tasks = new ArrayList<>();
            List<Employee> teamMembers = employeeDAO.getTeamMembers(displayName);
            if (projectIdStr != null && !projectIdStr.isEmpty()) {
                try {
                    int projectId = Integer.parseInt(projectIdStr);
                    List<Project> projects = projectDAO.getProjects(teamLeaderId);
                    selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst()
                            .orElse(null);
                    if (selectedProject == null) {
                        request.setAttribute("errorMessage", "Project not assigned to you.");
                    } else {
                        tasks = taskDAO.getTasksByProject(projectId, teamLeaderId);
                        if (tasks.isEmpty()) {
                            request.setAttribute("errorMessage", "No tasks found for project ID: " + projectId);
                        }
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid project ID.");
                }
            }
            request.setAttribute("selectedProject", selectedProject);
            request.setAttribute("tasks", tasks);
            request.setAttribute("teamMembers", teamMembers);
            includePath = "tasks-by-project.jsp";
        } else {
            List<Task> tasks = taskDAO.getTasksByTeamLeader(teamLeaderId);
            List<Project> projects = projectDAO.getProjects(teamLeaderId);
            request.setAttribute("tasks", tasks);
            request.setAttribute("projects", projects);
            LOGGER.info("All tasks size (default): " + (tasks != null ? tasks.size() : "null"));
            includePath = "tasks.jsp";
        }

        LOGGER.info("Forwarding to TeamLeaderDashboard.jsp with includePath: " + includePath + ", contentType: " + contentType + ", taskFilter: " + taskFilter);
        request.setAttribute("includePath", includePath);
        request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("POST request received at TeamLeaderTaskServlet with action: " + request.getParameter("action"));
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

        String action = request.getParameter("action");
        String contentType = request.getParameter("contentType") != null ? request.getParameter("contentType") : "tasks";
        String taskFilter = "all";
        if ("pending-tasks".equals(contentType)) {
            taskFilter = "pending";
        } else if ("completed-tasks".equals(contentType)) {
            taskFilter = "completed";
        }
        request.setAttribute("taskFilter", taskFilter);
        request.setAttribute("contentType", contentType);

        String includePath = "tasks.jsp"; // Default includePath

        if ("createTask".equals(action)) {
            try {
                String taskTitle = request.getParameter("taskTitle");
                String description = request.getParameter("description");
                String projectIdStr = request.getParameter("projectId");
                String deadlineDateStr = request.getParameter("deadlineDate");

                if (taskTitle == null || taskTitle.trim().isEmpty()) {
                    throw new IllegalArgumentException("Task title is required.");
                }
                if (description == null || description.trim().isEmpty()) {
                    throw new IllegalArgumentException("Description is required.");
                }
                if (projectIdStr == null || projectIdStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Project selection is required.");
                }
                if (deadlineDateStr == null || deadlineDateStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Deadline date is required.");
                }

                int projectId;
                try {
                    projectId = Integer.parseInt(projectIdStr);
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Invalid project ID.");
                }

                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                boolean validProject = projects.stream().anyMatch(p -> p.getProjectId() == projectId);
                if (!validProject) {
                    throw new IllegalArgumentException("Selected project is not assigned to you.");
                }

                Task task = new Task();
                task.setTaskTitle(taskTitle);
                task.setDescription(description);
                task.setProjectId(projectId);
                try {
                    task.setDeadlineDate(Date.valueOf(deadlineDateStr));
                } catch (IllegalArgumentException e) {
                    throw new IllegalArgumentException("Invalid deadline date format.");
                }
                task.setStatus("Pending");
                task.setProgressPercentage(0);
                task.setAssignByTeamLeaderId(teamLeaderId);

                boolean created = taskDAO.createTask(task, teamLeaderId);

                if (created) {
                    request.setAttribute("successMessage", "Task created successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to create task. Please try again.");
                }
                List<Task> tasks = taskDAO.getTasksByTeamLeader(teamLeaderId);
                request.setAttribute("tasks", tasks);
                request.setAttribute("projects", projects);
                LOGGER.info("Tasks size after create: " + (tasks != null ? tasks.size() : "null"));
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.setAttribute("projects", projectDAO.getProjects(teamLeaderId));
                includePath = "create-task.jsp";
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Unexpected error creating task: " + e.getMessage());
                request.setAttribute("projects", projectDAO.getProjects(teamLeaderId));
                includePath = "create-task.jsp";
            }
        } else if ("assignTask".equals(action)) {
            try {
                String taskIdStr = request.getParameter("taskId");
                String employeeIdStr = request.getParameter("employeeId");
                String projectIdStr = request.getParameter("projectId");

                int taskId = Integer.parseInt(taskIdStr);
                int employeeId = Integer.parseInt(employeeIdStr);
                int projectId = Integer.parseInt(projectIdStr);

                Task task = taskDAO.getTaskById(taskId);
                if (task == null || task.getProjectId() != projectId) {
                    request.setAttribute("errorMessage", "Invalid task or project.");
                } else if (!projectDAO.getProjects(teamLeaderId).stream()
                        .anyMatch(p -> p.getProjectId() == projectId)) {
                    request.setAttribute("errorMessage", "Project not assigned to you.");
                } else if (!employeeDAO.isEmployeeAssignedToProject(employeeId, projectId)) {
                    request.setAttribute("errorMessage", "Employee is not assigned to this project.");
                } else {
                    taskDAO.assignTaskToEmployee(taskId, employeeId, projectId, teamLeaderId);
                    request.setAttribute("successMessage", "Task assigned successfully.");
                }

                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                List<Task> tasks = taskDAO.getTasksByProject(projectId, teamLeaderId);
                List<Employee> teamMembers = employeeDAO.getEmployeesByProject(projectId);
                request.setAttribute("projects", projects);
                request.setAttribute("tasks", tasks);
                request.setAttribute("teamMembers", teamMembers);
                request.setAttribute("selectedProjectId", String.valueOf(projectId));
                includePath = "assign-task.jsp";
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid task, employee, or project ID.");
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                request.setAttribute("projects", projects);
                includePath = "assign-task.jsp";
            } catch (RuntimeException e) {
                request.setAttribute("errorMessage", "Failed to assign task: " + e.getMessage());
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                request.setAttribute("projects", projects);
                includePath = "assign-task.jsp";
            }
        }

        LOGGER.info("Forwarding to TeamLeaderDashboard.jsp with includePath: " + includePath + ", action: " + action + ", taskFilter: " + taskFilter);
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