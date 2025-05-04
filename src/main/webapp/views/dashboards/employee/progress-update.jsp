<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.Task"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Task Progress | Efficio</title>
    <!-- Project-specific styling ke liye view-projects.css -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/view-projects.css">
    <!-- Font Awesome icons ke liye -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>

    <!-- Main container -->
    <div class="proj-list-container">
        <%
            Task task = (Task) request.getAttribute("taskDetails");
            String errorMessage = (String) request.getAttribute("errorMessage");
            String successMessage = (String) request.getAttribute("successMessage");
            String filter = (String) request.getAttribute("filter");
            if (filter == null) filter = "all";
        %>
        <div class="proj-edit">
            <div class="proj-header">
                <a href="?contentType=tasks&filter=<%= filter %>" class="proj-back-btn">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
                <h1><i class="fas fa-edit"></i> Update Progress for <%= task != null && task.getTaskTitle() != null ? task.getTaskTitle() : "Task" %></h1>
            </div>
            <%-- Success message ke liye --%>
            <% if (successMessage != null) { %>
                <p class="proj-success-msg">
                    <i class="fas fa-check-circle"></i> <%= successMessage %>
                </p>
            <% } %>
            <%-- Error message ke liye --%>
            <% if (errorMessage != null) { %>
                <p class="proj-no-data">
                    <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
                </p>
            <% } %>
            <% if (task == null) { %>
                <p class="proj-no-data">
                    <i class="fas fa-info-circle"></i> Task not found.
                </p>
            <% } else { %>
                <div class="proj-form-group">
                    <label><i class="fas fa-chart-line"></i> Current Progress:</label>
                    <div class="proj-progress-bar">
                        <div class="progress-container">
                            <div class="progress" style="width: <%= task.getProgressPercentage() %>%;"></div>
                        </div>
                        <span><%= task.getProgressPercentage() %>%</span>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/EmployeeTaskServlet" method="post">
                    <input type="hidden" name="action" value="updateProgress">
                    <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                    <input type="hidden" name="contentType" value="progress-update">
                    <input type="hidden" name="filter" value="<%= filter %>">
                    <div class="proj-form-group">
                        <label for="progressPercentage"><i class="fas fa-chart-line"></i> New Progress (%):</label>
                        <input type="number" name="progressPercentage" id="progressPercentage" min="0" max="100" value="<%= task.getProgressPercentage() %>" required>
                    </div>
                    <div class="proj-form-group">
                        <label for="progressMessage"><i class="fas fa-comment"></i> Progress Update Message:</label>
                        <textarea name="progressMessage" id="progressMessage" rows="5" placeholder="Enter details about the progress update"><%= task.getProgressMessage() != null ? task.getProgressMessage() : "" %></textarea>
                    </div>
                    <div class="proj-form-actions">
                        <button type="submit" class="proj-btn proj-success">
                            <i class="fas fa-save"></i> Save Progress
                        </button>
                    </div>
                </form>
            <% } %>
        </div>
    </div>
</body>
</html>