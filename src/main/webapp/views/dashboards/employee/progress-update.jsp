<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.Task"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Task Progress | Efficio</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/views/assets/css/employee/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <nav class="navbar">
        <a href="#" class="nav-brand"><i class="fas fa-edit"></i> Update Task Progress</a>
    </nav>
    <div class="progress-update-container">
        <%
            Task task = (Task) request.getAttribute("taskDetails");
            String errorMessage = (String) request.getAttribute("errorMessage");
            String successMessage = (String) request.getAttribute("successMessage");
            String filter = (String) request.getAttribute("filter");
            if (filter == null) filter = "all";
        %>
        <div class="proj-details">
            <div class="proj-header">
                <a href="?contentType=tasks&filter=<%= filter %>" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
                <h1><i class="fas fa-edit"></i> Update Progress for <%= task != null && task.getTaskTitle() != null ? task.getTaskTitle() : "Task" %></h1>
            </div>
            <% if (successMessage != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= successMessage %>
                </div>
            <% } %>
            <% if (errorMessage != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
                </div>
            <% } %>
            <% if (task == null) { %>
                <div class="no-data">
                    <i class="fas fa-info-circle"></i> Task not found.
                </div>
            <% } else { %>
                <div class="proj-progress-bar">
                    <label><i class="fas fa-chart-line"></i> Current Progress:</label>
                    <div class="progress-container">
                        <div class="progress" style="width: <%= task.getProgressPercentage() %>%;"></div>
                    </div>
                    <span><%= task.getProgressPercentage() %>%</span>
                </div>
                <form action="${pageContext.request.contextPath}/EmployeeTaskServlet" method="post">
                    <input type="hidden" name="action" value="updateProgress">
                    <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                    <input type="hidden" name="contentType" value="progress-update">
                    <input type="hidden" name="filter" value="<%= filter %>">
                    <div class="form-group">
                        <label for="progressPercentage"><i class="fas fa-chart-line"></i> New Progress (%):</label>
                        <input type="number" name="progressPercentage" id="progressPercentage" min="0" max="100" value="<%= task.getProgressPercentage() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="progressMessage"><i class="fas fa-comment"></i> Progress Update Message:</label>
                        <textarea name="progressMessage" id="progressMessage" rows="5" placeholder="Enter details about the progress update"><%= task.getProgressMessage() != null ? task.getProgressMessage() : "" %></textarea>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn-success">
                            <i class="fas fa-save"></i> Save Progress
                        </button>
                    </div>
                </form>
            <% } %>
        </div>
    </div>
</body>
</html>