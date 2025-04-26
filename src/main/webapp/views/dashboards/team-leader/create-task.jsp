<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Task</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/create-project.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const dateInput = document.querySelector('input[type="date"].date-input');
            if (dateInput) {
                dateInput.addEventListener('click', function () {
                    this.showPicker();
                });
            }
        });
    </script>
</head>
<body>
    <div class="create-project-container">
        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
        <% String successMessage = (String) request.getAttribute("successMessage"); %>
        <% if (errorMessage != null) { %>
            <div class="alert alert-error"><%= errorMessage %></div>
        <% } %>
        <% if (successMessage != null) { %>
            <div class="alert alert-success"><%= successMessage %></div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/TeamLeaderTaskServlet" method="post">
            <input type="hidden" name="action" value="createTask">
            <input type="hidden" name="status" value="Pending"> <!-- Set status to Pending -->
            
            <div class="form-group">
                <label for="projectId"><i class="fas fa-project-diagram"></i> Project:</label>
                <select name="projectId" id="projectId" required>
                    <option value="">Select Project</option>
                    <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
                    <% if (projects != null && !projects.isEmpty()) { %>
                        <% for (Project project : projects) { %>
                            <option value="<%= project.getProjectId() %>"><%= project.getProjectName() %></option>
                        <% } %>
                    <% } else { %>
                        <option value="" disabled>No projects available</option>
                    <% } %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="taskTitle"><i class="fas fa-tasks"></i> Task Title:</label>
                <input type="text" name="taskTitle" id="taskTitle" value="<%= request.getParameter("taskTitle") != null ? request.getParameter("taskTitle") : "" %>" required>
            </div>
            
            <div class="form-group">
                <label for="description"><i class="fas fa-file-alt"></i> Description:</label>
                <textarea name="description" id="description" required><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
            </div>
            
            <div class="form-group">
                <label for="deadlineDate"><i class="fas fa-calendar-alt"></i> Deadline Date:</label>
                <input type="date" name="deadlineDate" id="deadlineDate" class="date-input" value="<%= request.getParameter("deadlineDate") != null ? request.getParameter("deadlineDate") : "" %>" required>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn"><i class="fas fa-check"></i> Create Task</button>
            </div>
        </form>
    </div>
</body>
</html>