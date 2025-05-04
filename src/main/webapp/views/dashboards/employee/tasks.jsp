<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task, in.efficio.model.DashboardStats, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tasks | Efficio</title>
    <!-- Base styling ke liye lists.css -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/lists.css">

    <!-- Font Awesome icons ke liye -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <!-- Task list ka main container -->
    <div class="employee-list-container">

        <%-- Success ya error messages ke liye alerts --%>
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

        <%-- Total tasks count display (right-aligned) --%>
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

        <%-- Task filtering ke liye buttons (right-aligned) --%>
        <div class="filter-buttons">
            <%
                String filter = (String) request.getAttribute("filter");
                if (filter == null) filter = "all";
                String allClass = "view-btn" + ("all".equals(filter) ? " active" : "");
                String pendingClass = "view-btn" + ("pending".equals(filter) ? " active" : "");
                String completedClass = "view-btn" + ("completed".equals(filter) ? " active" : "");
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

        <%-- Tasks display ke liye table --%>
        <div class="table-wrapper">
            <table class="table-modern">
                <thead>
                    <tr id="heading">
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