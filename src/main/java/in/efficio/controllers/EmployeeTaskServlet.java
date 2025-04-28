package in.efficio.controllers;

import in.efficio.dao.DashboardDAO;
import in.efficio.dao.ProjectDAO;
import in.efficio.dao.TaskDAO;
import in.efficio.model.DashboardStats;
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

@WebServlet("/EmployeeTaskServlet")
public class EmployeeTaskServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EmployeeTaskServlet.class.getName());
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

        String action = request.getParameter("action");
        String taskIdStr = request.getParameter("taskId");
        String contentType = request.getParameter("contentType") != null ? request.getParameter("contentType") : "tasks";
        String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "all";
        String includePath = "tasks.jsp";

        // Prepare DashboardStats
        DashboardStats stats = new DashboardStats();
        updateStats(stats, employeeId);
        request.setAttribute("stats", stats);

        // Handle task filtering
        List<Task> tasks;
        if ("pending".equals(filter)) {
            tasks = taskDAO.getTasksByEmployeeIdAndStatus(employeeId, "Pending");
        } else if ("completed".equals(filter)) {
            tasks = taskDAO.getTasksByEmployeeIdAndStatus(employeeId, "Completed");
        } else {
            tasks = taskDAO.getTasksByEmployeeId(employeeId);
        }
        request.setAttribute("tasks", tasks);
        request.setAttribute("filter", filter);

        if ("view".equals(action) && taskIdStr != null && !taskIdStr.isEmpty()) {
            try {
                int taskId = Integer.parseInt(taskIdStr);
                Task task = taskDAO.getTaskById(taskId);
                if (task == null || !task.getAssignedToEmployeeId().equals(employeeId)) {
                    request.setAttribute("errorMessage", "Task not found or not assigned to you.");
                    includePath = "tasks.jsp";
                } else {
                    Project project = projectDAO.getProjectById(task.getProjectId());
                    request.setAttribute("taskDetails", task);
                    request.setAttribute("project", project);
                    includePath = "task-details.jsp";
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid task ID.");
                includePath = "tasks.jsp";
            }
        } else if ("updateProgress".equals(action) && taskIdStr != null && !taskIdStr.isEmpty()) {
            try {
                int taskId = Integer.parseInt(taskIdStr);
                Task task = taskDAO.getTaskById(taskId);
                if (task == null || !task.getAssignedToEmployeeId().equals(employeeId)) {
                    request.setAttribute("errorMessage", "Task not found or not assigned to you.");
                    includePath = "tasks.jsp";
                } else {
                    request.setAttribute("taskDetails", task);
                    includePath = "progress-update.jsp";
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid task ID.");
                includePath = "tasks.jsp";
            }
        }

        request.setAttribute("contentType", contentType);
        request.setAttribute("includePath", includePath);
        request.getRequestDispatcher("/views/dashboards/employee/EmployeeDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        Integer employeeId = (Integer) session.getAttribute("employeeId");
        if (employeeId == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Invalid session: Employee ID missing.");
            return;
        }

        String action = request.getParameter("action");
        String contentType = request.getParameter("contentType") != null ? request.getParameter("contentType") : "tasks";
        String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "all";
        String includePath = "tasks.jsp";

        // Prepare DashboardStats
        DashboardStats stats = new DashboardStats();
        updateStats(stats, employeeId);
        request.setAttribute("stats", stats);

        if ("updateProgress".equals(action)) {
            try {
                String taskIdStr = request.getParameter("taskId");
                String progressStr = request.getParameter("progressPercentage");

                int taskId = Integer.parseInt(taskIdStr);
                int progress = Integer.parseInt(progressStr);

                if (progress < 0 || progress > 100) {
                    throw new IllegalArgumentException("Progress must be between 0 and 100.");
                }

                Task task = taskDAO.getTaskById(taskId);
                if (task == null || !task.getAssignedToEmployeeId().equals(employeeId)) {
                    throw new IllegalArgumentException("Task not found or not assigned to you.");
                }

                task.setProgressPercentage(progress);
                task.setStatus(progress == 100 ? "Completed" : "Pending");
                taskDAO.updateTask(task);

                request.setAttribute("successMessage", "Progress updated successfully!");
                List<Task> tasks = "pending".equals(filter) ? taskDAO.getTasksByEmployeeIdAndStatus(employeeId, "Pending") :
                                  "completed".equals(filter) ? taskDAO.getTasksByEmployeeIdAndStatus(employeeId, "Completed") :
                                  taskDAO.getTasksByEmployeeId(employeeId);
                request.setAttribute("tasks", tasks);
                request.setAttribute("filter", filter);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid progress value.");
                Task task = taskDAO.getTaskById(Integer.parseInt(request.getParameter("taskId")));
                request.setAttribute("taskDetails", task);
                includePath = "progress-update.jsp";
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                Task task = taskDAO.getTaskById(Integer.parseInt(request.getParameter("taskId")));
                request.setAttribute("taskDetails", task);
                includePath = "progress-update.jsp";
            }
        }

        request.setAttribute("contentType", contentType);
        request.setAttribute("includePath", includePath);
        request.getRequestDispatcher("/views/dashboards/employee/EmployeeDashboard.jsp").forward(request, response);
    }

    private void updateStats(DashboardStats stats, int employeeId) {
        stats.setProjectCount(new DashboardDAO().getEmployeeProjectCount(employeeId));
        stats.setTaskCount(taskDAO.getEmployeeTaskCount(employeeId));
        stats.setPendingTaskCount(taskDAO.getEmployeePendingTaskCount(employeeId));
        stats.setCompletedTaskCount(taskDAO.getEmployeeCompletedTaskCount(employeeId));
        int totalTasks = stats.getPendingTaskCount() + stats.getCompletedTaskCount();
        stats.setProductivity(totalTasks > 0 ? (stats.getCompletedTaskCount() * 100.0) / totalTasks : 0);
    }
}