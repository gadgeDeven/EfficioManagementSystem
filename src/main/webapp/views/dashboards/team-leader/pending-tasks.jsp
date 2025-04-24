<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task, in.efficio.model.Project, in.efficio.model.Employee, in.efficio.model.TeamLeader"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pending Tasks</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/lists.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/view-projects.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="proj-list-container">
    <%
        // Initialize variables
        String action = request.getParameter("action");
        String contentType = request.getParameter("contentType") != null ? request.getParameter("contentType") : "pending-tasks";
        String errorMessage = (String) request.getAttribute("errorMessage");

        // Check for view action
        if ("view".equals(action)) {
            Task task = (Task) request.getAttribute("taskDetails");
            Project project = (Project) request.getAttribute("project");
            TeamLeader teamLeader = (TeamLeader) request.getAttribute("teamLeader");
            Employee employee = (Employee) request.getAttribute("employee");
            Integer progress = task != null ? task.getProgressPercentage() : null;
    %>
            <!-- Detailed View -->
            <% if (errorMessage != null) { %>
                <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> <%= errorMessage %></p>
            <% } %>
            <% if (task == null) { %>
                <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> Task not found.</p>
            <% } else { %>
                <div class="proj-details">
                    <div class="proj-header">
                        <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=<%= contentType %>'"><i class="fas fa-arrow-left"></i> Back</button>
                        <h1><i class="fas fa-tasks"></i> <%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></h1>
                    </div>
                    <div class="proj-details-grid">
                        <p class="proj-description"><strong><i class="fas fa-info-circle"></i> Description:</strong> <%= task.getDescription() != null ? task.getDescription() : "N/A" %></p>
                        <div class="proj-date-status-grid">
                            <p><strong><i class="fas fa-project-diagram"></i> Project:</strong> <%= project != null && project.getProjectName() != null ? project.getProjectName() : "N/A" %></p>
                            <p><strong><i class="fas fa-calendar-check"></i> Deadline:</strong> <%= task.getDeadlineDate() != null ? task.getDeadlineDate() : "N/A" %></p>
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
                    <h3><i class="fas fa-user-tie"></i> Assigned By Team Leader</h3>
                    <div class="proj-team-list">
                        <% if (teamLeader != null) { %>
                            <div class="proj-team-item">
                                <%= teamLeader.getName() != null ? teamLeader.getName() : "N/A" %>
                            </div>
                        <% } else { %>
                            <p class="proj-no-data">No team leader assigned.</p>
                        <% } %>
                    </div>
                    <h3><i class="fas fa-users"></i> Assigned Employee</h3>
                    <div class="proj-employee-list">
                        <% if (employee != null) { %>
                            <div class="proj-employee-item">
                                <%= employee.getName() != null ? employee.getName() : "N/A" %>
                            </div>
                        <% } else { %>
                            <p class="proj-no-data">No employee assigned.</p>
                        <% } %>
                    </div>
                </div>
            <% } %>
    <%
        } else {
            // List View
            List<Task> pendingTasks = (List<Task>) request.getAttribute("pendingTasks");
            // Debug output
            System.out.println("pending-tasks.jsp: pendingTasks = " + (pendingTasks != null ? pendingTasks.size() : "null"));
    %>
            <h1>Pending Tasks</h1>
            <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'"><i class="fas fa-arrow-left"></i> Back</button>
            <% if (errorMessage != null) { %>
                <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> <%= errorMessage %></p>
            <% } %>
            <% if (pendingTasks != null && !pendingTasks.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Task Title</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Deadline</th>
                            <th>Assigned To</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Task task : pendingTasks) { %>
                            <tr>
                                <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
                                <td><%= task.getDescription() != null ? task.getDescription() : "N/A" %></td>
                                <td><%= task.getStatus() != null ? task.getStatus() : "N/A" %></td>
                                <td><%= task.getDeadlineDate() != null ? task.getDeadlineDate() : "N/A" %></td>
                                <td><%= task.getAssignedToEmployeeId() != null ? "Employee ID: " + task.getAssignedToEmployeeId() : "Unassigned" %></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=<%= contentType %>&action=view&taskId=<%= task.getTaskId() %>" class="proj-btn"><i class="fas fa-eye"></i> View</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> No pending tasks found.</p>
            <% } %>
    <% } %>
</div>
</body>
</html>