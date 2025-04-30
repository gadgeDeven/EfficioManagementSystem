<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task, in.efficio.model.DashboardStats, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tasks | Efficio</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/views/assets/css/employee/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <nav class="navbar">
        <a href="#" class="nav-brand"><i class="fas fa-tasks"></i> Your Tasks</a>
    </nav>
    <div class="employee-list-container">
        <h1><i class="fas fa-tasks"></i> Your Tasks</h1>
        <%-- Alerts --%>
        <%
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (successMessage != null && !successMessage.isEmpty()) {
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= successMessage %>
            </div>
        <%
            }
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
        <%
            }
        %>

        <%-- Task Count --%>
        <%
            DashboardStats stats = (DashboardStats) request.getAttribute("stats");
            if (stats != null) {
        %>
            <div class="total-employees">
                <i class="fas fa-clipboard-list"></i> Total Tasks: <%= stats.getTaskCount() %>
            </div>
        <%
            }
        %>

        <%-- Filter Buttons --%>
        <div style="margin-bottom: 20px; text-align: center;">
            <%
                String filter = (String) request.getAttribute("filter");
                if (filter == null) filter = "all";
                String allClass = "action-btn" + ("all".equals(filter) ? " active" : "");
                String pendingClass = "action-btn" + ("pending".equals(filter) ? " active" : "");
                String completedClass = "action-btn" + ("completed".equals(filter) ? " active" : "");
            %>
            <a href="?contentType=tasks&filter=all" class="<%= allClass %>">
                <i class="fas fa-list"></i> All Tasks
            </a>
            <a href="?contentType=tasks&filter=pending" class="<%= pendingClass %>">
                <i class="fas fa-hourglass-half"></i> Pending
            </a>
            <a href="?contentType=tasks&filter=completed" class="<%= completedClass %>">
                <i class="fas fa-check-circle"></i> Completed
            </a>
        </div>

        <%-- Task Table --%>
        <div class="table-wrapper">
            <table class="table-modern">
                <thead>
                    <tr>
                        <th>Task Title</th>
                        <th>Project</th>
                        <th>Deadline</th>
                        <th>Status</th>
                        <th>Progress</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Task> tasks = (List<Task>) request.getAttribute("tasks");
                        if (tasks == null || tasks.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="6" class="no-data">
                                <i class="fas fa-info-circle"></i> No tasks available.
                            </td>
                        </tr>
                    <%
                        } else {
                            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                            for (Task task : tasks) {
                    %>
                        <tr>
                            <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
                            <td><%= task.getProjectName() != null ? task.getProjectName() : "N/A" %></td>
                            <td><%= task.getDeadlineDate() != null ? sdf.format(task.getDeadlineDate()) : "N/A" %></td>
                            <td><%= task.getStatus() != null ? task.getStatus() : "N/A" %></td>
                            <td>
                                <div class="progress-container">
                                    <div class="progress" style="width: <%= task.getProgressPercentage() %>%;"></div>
                                </div>
                                <span class="progress-text"><%= task.getProgressPercentage() %>%</span>
                            </td>
                            <td>
                                <a href="?action=view&taskId=<%= task.getTaskId() %>&contentType=tasks&filter=<%= filter %>" class="view-btn">
                                    <i class="fas fa-eye"></i> View
                                </a>
                            </td>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>