<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task, in.efficio.model.Project, in.efficio.model.Employee, in.efficio.model.TeamLeader, java.text.SimpleDateFormat, java.text.ParseException"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Task List | Efficio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/lists.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/view-projects.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="proj-list-container">
    <%
        String action = request.getParameter("action");
        String contentType = request.getParameter("contentType") != null ? request.getParameter("contentType") : "tasks";
        String taskFilter = request.getParameter("taskFilter") != null ? request.getParameter("taskFilter") : "all";
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");

        List<Task> pendingTasks = (List<Task>) request.getAttribute("pendingTasks");
        List<Task> completedTasks = (List<Task>) request.getAttribute("completedTasks");
        List<Task> tasks = null;
        if ("pending".equals(taskFilter)) {
            tasks = pendingTasks;
        } else if ("completed".equals(taskFilter)) {
            tasks = completedTasks;
        } else {
            tasks = (List<Task>) request.getAttribute("tasks");
        }
        List<Project> projects = (List<Project>) request.getAttribute("projects");
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
    %>

    <%-- List View --%>
    <% if (!"view".equals(action) && !"edit".equals(action)) { %>
        <%-- Filter Buttons --%>
        <div style="margin-bottom: 20px; text-align: center;">
            <%
                String allClass = "proj-btn" + ("all".equals(taskFilter) ? " active" : "");
                String pendingClass = "proj-btn" + ("pending".equals(taskFilter) ? " active" : "");
                String completedClass = "proj-btn" + ("completed".equals(taskFilter) ? " active" : "");
            %>
            <a href="${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=tasks&taskFilter=all" class="<%= allClass %>">
                <i class="fas fa-list"></i> All Tasks
            </a>
            <a href="${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=pending-tasks&taskFilter=pending" class="<%= pendingClass %>">
                <i class="fas fa-hourglass-half"></i> Pending
            </a>
            <a href="${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=completed-tasks&taskFilter=completed" class="<%= completedClass %>">
                <i class="fas fa-check-circle"></i> Completed
            </a>
        </div>

        <% if (successMessage != null) { %>
            <p class="proj-no-data success"><i class="fas fa-check-circle"></i> <%= successMessage %></p>
        <% } %>
        <% if (errorMessage != null) { %>
            <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> <%= errorMessage %></p>
        <% } %>

        <% if (tasks != null && !tasks.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>Task Title</th>
                        <% if ("all".equals(taskFilter)) { %>
                            <th>Project</th>
                        <% } else { %>
                            <th>Description</th>
                        <% } %>
                        <th>Status</th>
                        <th>Deadline</th>
                        <th>Assigned To</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Task task : tasks) {
                            if (task == null || task.getTaskId() == null) continue;
                    %>
                        <tr>
                            <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
                            <% if ("all".equals(taskFilter)) { %>
                                <td>
                                    <% 
                                        String projectName = "Unknown";
                                        if (projects != null && task.getProjectId() != null) {
                                            for (Project project : projects) {
                                                if (project != null && task.getProjectId().equals(project.getProjectId())) {
                                                    projectName = project.getProjectName() != null ? project.getProjectName() : "N/A";
                                                    break;
                                                }
                                            }
                                        }
                                    %>
                                    <%= projectName %>
                                </td>
                            <% } else { %>
                                <td><%= task.getDescription() != null ? task.getDescription() : "N/A" %></td>
                            <% } %>
                            <td><%= task.getStatus() != null ? task.getStatus() : "N/A" %></td>
                            <td>
                                <%
                                    String deadline = "N/A";
                                    if (task.getDeadlineDate() != null) {
                                        try {
                                            deadline = sdf.format(task.getDeadlineDate());
                                        } catch (Exception e) {
                                            deadline = "Invalid Date";
                                        }
                                    }
                                %>
                                <%= deadline %>
                            </td>
                            <td><%= task.getAssignedToEmployeeId() != null ? "Employee ID: " + task.getAssignedToEmployeeId() : "Unassigned" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=<%= contentType %>&taskFilter=<%= taskFilter %>&action=view&taskId=<%= task.getTaskId() %>" class="proj-btn">
                                    <i class="fas fa-eye"></i> View
                                </a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> No <%= "pending".equals(taskFilter) ? "pending" : "completed".equals(taskFilter) ? "completed" : "" %> tasks found.</p>
        <% } %>

    <%-- Detailed View --%>
    <% } else if ("view".equals(action)) { %>
        <%
            Task task = (Task) request.getAttribute("taskDetails");
            Project project = (Project) request.getAttribute("project");
            Employee employee = (Employee) request.getAttribute("employee");
            Integer progress = task != null ? task.getProgressPercentage() : null;
        %>
        <div class="proj-details">
            <% if (successMessage != null) { %>
                <p class="proj-no-data success"><i class="fas fa-check-circle"></i> <%= successMessage %></p>
            <% } %>
            <% if (errorMessage != null) { %>
                <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> <%= errorMessage %></p>
            <% } %>
            <% if (task == null || task.getTaskId() == null) { %>
                <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> Task not found.</p>
            <% } else { %>
                <div class="proj-header">
                    <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=<%= contentType %>&taskFilter=<%= taskFilter %>'">
                        <i class="fas fa-arrow-left"></i> Back
                    </button>
                    <h1><i class="fas fa-tasks"></i> <%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></h1>
                </div>
                <div class="proj-details-grid">
                    <p class="proj-description"><strong><i class="fas fa-info-circle"></i> Description:</strong> <%= task.getDescription() != null ? task.getDescription() : "N/A" %></p>
                    <div class="proj-date-status-grid">
                        <p><strong><i class="fas fa-project-diagram"></i> Project:</strong> <%= project != null && project.getProjectName() != null ? project.getProjectName() : "N/A" %></p>
                        <p><strong><i class="fas fa-calendar-check"></i> Deadline:</strong> 
                            <%
                                String deadline = "N/A";
                                if (task.getDeadlineDate() != null) {
                                    try {
                                        deadline = sdf.format(task.getDeadlineDate());
                                    } catch (Exception e) {
                                        deadline = "Invalid Date";
                                    }
                                }
                            %>
                            <%= deadline %>
                        </p>
                        <p><strong><i class="fas fa-tasks"></i> Status:</strong> <%= task.getStatus() != null ? task.getStatus() : "N/A" %></p>
                    </div>
                    <div class="proj-progress-bar">
                        <label><i class="fas fa-chart-line"></i> Progress:</label>
                        <div class="progress-container">
                            <div class="progress" style="width: <%= progress != null ? progress : 0 %>%;"></div>
                        </div>
                        <span><%= progress != null ? progress : 0 %>%</span>
                    </div>
                </div>
                <h3><i class="fas fa-users"></i> Assigned Employee</h3>
                <div class="proj-employee-list">
                    <% if (employee != null && employee.getEmployee_id() != 0) { %>
                        <div class="proj-employee-item">
                            <a href="${pageContext.request.contextPath}/TeamLeaderTeamServlet?contentType=employee-details&action=view&employeeId=<%= employee.getEmployee_id() %>">
                                <%= employee.getName() != null ? employee.getName() : "N/A" %>
                            </a>
                        </div>
                    <% } else { %>
                        <p class="proj-no-data">No employee assigned.</p>
                    <% } %>
                </div>
                <div class="proj-actions">
                    <form action="${pageContext.request.contextPath}/DeleteTask" method="post" style="display:inline;">
                        <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                        <input type="hidden" name="contentType" value="<%= contentType %>">
                        <input type="hidden" name="taskFilter" value="<%= taskFilter %>">
                        <button type="submit" class="proj-btn proj-danger" onclick="return confirm('Are you sure you want to delete this task?');">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </form>
                    <a href="${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=<%= contentType %>&taskFilter=<%= taskFilter %>&action=edit&taskId=<%= task.getTaskId() %>" class="proj-btn">
                        <i class="fas fa-edit"></i> Edit
                    </a>
                    <a href="${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=<%= contentType %>&taskFilter=<%= taskFilter %>&action=download&taskId=<%= task.getTaskId() %>" class="proj-btn">
                        <i class="fas fa-download"></i> Download
                    </a>
                </div>
            <% } %>
        </div>

    <%-- Edit View --%>
    <% } else if ("edit".equals(action)) { %>
        <%
            Task task = (Task) request.getAttribute("taskDetails");
        %>
        <div class="proj-edit">
            <div class="proj-header">
                <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=<%= contentType %>&taskFilter=<%= taskFilter %>&action=view&taskId=<%= task.getTaskId() %>'">
                    <i class="fas fa-arrow-left"></i> Back
                </button>
                <h1><i class="fas fa-edit"></i> Edit <%= task.getTaskTitle() != null ? task.getTaskTitle() : "Task" %></h1>
            </div>
            <form action="${pageContext.request.contextPath}/TeamLeaderTaskServlet" method="post">
                <input type="hidden" name="action" value="updateTask">
                <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                <input type="hidden" name="contentType" value="<%= contentType %>">
                <input type="hidden" name="taskFilter" value="<%= taskFilter %>">
                <div class="proj-form-group">
                    <label><i class="fas fa-tasks"></i> Task Title:</label>
                    <input type="text" name="taskTitle" value="<%= task.getTaskTitle() != null ? task.getTaskTitle() : "" %>" required>
                </div>
                <div class="proj-form-group">
                    <label><i class="fas fa-info-circle"></i> Description:</label>
                    <textarea name="description" required><%= task.getDescription() != null ? task.getDescription() : "" %></textarea>
                </div>
                <div class="proj-form-group">
                    <label><i class="fas fa-calendar-check"></i> Deadline Date:</label>
                    <%
                        String deadlineDateStr = "";
                        if (task.getDeadlineDate() != null) {
                            try {
                                deadlineDateStr = new SimpleDateFormat("yyyy-MM-dd").format(task.getDeadlineDate());
                            } catch (Exception e) {
                                deadlineDateStr = "";
                            }
                        }
                    %>
                    <input type="date" name="deadlineDate" value="<%= deadlineDateStr %>" required>
                </div>
                <div class="proj-form-actions">
                    <button type="submit" class="proj-btn"><i class="fas fa-save"></i> Save Changes</button>
                </div>
            </form>
        </div>
    <% } %>
</div>
</body>
</html>