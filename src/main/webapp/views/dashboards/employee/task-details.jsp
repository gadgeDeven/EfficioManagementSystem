<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.Task, in.efficio.model.Project"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Task Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <div class="task-details-container">
        <%
            Task task = (Task) request.getAttribute("taskDetails");
            Project project = (Project) request.getAttribute("project");
            String errorMessage = (String) request.getAttribute("errorMessage");
            String filter = (String) request.getAttribute("filter");
            if (filter == null) filter = "all";
        %>
        <div class="task-header">
            <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/EmployeeTaskServlet?contentType=tasks&filter=<%= filter %>'">
                <i class="fas fa-arrow-left"></i> Back
            </button>
            <h1><i class="fas fa-tasks"></i> <%= task != null && task.getTaskTitle() != null ? task.getTaskTitle() : "Task Details" %></h1>
        </div>
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
            <div class="task-details">
                <p><strong><i class="fas fa-info-circle"></i> Description:</strong> <%= task.getDescription() != null ? task.getDescription() : "N/A" %></p>
                <p><strong><i class="fas fa-project-diagram"></i> Project:</strong> <%= project != null && project.getProjectName() != null ? project.getProjectName() : "N/A" %></p>
                <p><strong><i class="fas fa-calendar-check"></i> Deadline:</strong> <%= task.getDeadlineDate() != null ? task.getDeadlineDate() : "N/A" %></p>
                <p><strong><i class="fas fa-tasks"></i> Status:</strong> <%= task.getStatus() != null ? task.getStatus() : "N/A" %></p>
                <div class="progress-bar">
                    <label><i class="fas fa-chart-line"></i> Progress:</label>
                    <div class="progress-container">
                        <div class="progress" style="width: <%= task.getProgressPercentage() %>%;"></div>
                    </div>
                    <span><%= task.getProgressPercentage() %>%</span>
                </div>
            </div>
        <% } %>
    </div>
    <style>
    .task-details-container {
        max-width: 800px;
        margin: 20px auto;
        padding: 20px;
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }
    .task-header {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 20px;
    }
    .back-btn {
        background: #00a1a7;
        color: #ffffff;
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        cursor: pointer;
    }
    .back-btn:hover {
        background: #00888f;
        transform: translateY(-2px);
    }
    .task-header h1 {
        color: #6b48ff;
        font-size: 28px;
        flex: 1;
        text-align: center;
    }
    .task-details p {
        margin: 10px 0;
        font-size: 14px;
        color: #2d3748;
    }
    .task-details p strong {
        color: #6b21a8;
        min-width: 120px;
        display: inline-block;
    }
    .progress-bar {
        display: flex;
        align-items: center;
        gap: 16px;
    }
    .progress-container {
        width: 200px;
        height: 10px;
        background: #e0e0e0;
        border-radius: 5px;
    }
    .progress {
        height: 100%;
        background: #28a745;
        border-radius: 5px;
    }
    .alert-error {
        background: rgba(220, 53, 69, 0.1);
        color: #dc3545;
        border: 1px solid #dc3545;
        padding: 12px;
        border-radius: 6px;
    }
    .no-data {
        font-size: 14px;
        color: #dc3545;
        text-align: center;
        padding: 20px;
    }
    </style>