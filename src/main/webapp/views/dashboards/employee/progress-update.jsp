<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.Task"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Task Progress</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <div class="progress-update-container">
        <%
            Task task = (Task) request.getAttribute("taskDetails");
            String errorMessage = (String) request.getAttribute("errorMessage");
            String successMessage = (String) request.getAttribute("successMessage");
        %>
        <div class="progress-header">
            <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/EmployeeTaskServlet?contentType=tasks'">
                <i class="fas fa-arrow-left"></i> Back
            </button>
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
            <form action="${pageContext.request.contextPath}/EmployeeTaskServlet" method="post">
                <input type="hidden" name="action" value="updateProgress">
                <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                <input type="hidden" name="contentType" value="progress-update">
                <div class="form-group">
                    <label for="progressPercentage"><i class="fas fa-chart-line"></i> Progress (%):</label>
                    <input type="number" name="progressPercentage" id="progressPercentage" min="0" max="100" value="<%= task.getProgressPercentage() %>" required>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn-success">
                        <i class="fas fa-save"></i> Save Progress
                    </button>
                </div>
            </form>
        <% } %>
    </div>
    <style>
    .progress-update-container {
        max-width: 600px;
        margin: 20px auto;
        padding: 20px;
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }
    .progress-header {
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
    .progress-header h1 {
        color: #6b48ff;
        font-size: 28px;
        flex: 1;
        text-align: center;
    }
    .form-group {
        margin: 15px 0;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .form-group label {
        font-size: 14px;
        font-weight: 600;
        color: #6b21a8;
        width: 120px;
    }
    .form-group input {
        flex: 1;
        padding: 10px;
        border: 1px solid #d1d5db;
        border-radius: 6px;
        font-size: 14px;
    }
    .form-actions {
        text-align: center;
        margin-top: 20px;
    }
    .btn-success {
        background: #d97706;
        color: #ffffff;
        padding: 10px 20px;
        border: none;
        border-radius: 6px;
        font-size: 14px;
        cursor: pointer;
    }
    .btn-success:hover {
        background: #b45309;
        transform: translateY(-2px);
    }
    .alert {
        padding: 12px;
        margin-bottom: 15px;
        border-radius: 6px;
        font-size: 14px;
        display: flex;
        align-items: center;
    }
    .alert-success {
        background: rgba(40, 167, 69, 0.1);
        color: #28a745;
        border: 1px solid #28a745;
    }
    .alert-error {
        background: rgba(220, 53, 69, 0.1);
        color: #dc3545;
        border: 1px solid #dc3545;
    }
    .no-data {
        font-size: 14px;
        color: #dc3545;
        text-align: center;
        padding: 20px;
    }
    </style>
</body>
</html>