<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project"%>
<h1>Create Task</h1>
<button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=tasks'"><i class="fas fa-arrow-left"></i> Back</button>
<div class="create-task-container">
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% String successMessage = (String) request.getAttribute("successMessage"); %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>
    <% if (successMessage != null) { %>
        <div class="alert alert-success"><%= successMessage %></div>
    <% } %>
    <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="post">
        <input type="hidden" name="action" value="createTask">
        <div class="form-group">
            <label for="projectId">Project:</label>
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
            <label for="taskTitle">Task Title:</label>
            <input type="text" name="taskTitle" id="taskTitle" value="<%= request.getParameter("taskTitle") != null ? request.getParameter("taskTitle") : "" %>" required>
        </div>
        <div class="form-group">
            <label for="description">Description:</label>
            <textarea name="description" id="description" required><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
        </div>
        <div class="form-group">
            <label for="deadlineDate">Deadline Date:</label>
            <input type="date" name="deadlineDate" id="deadlineDate" value="<%= request.getParameter("deadlineDate") != null ? request.getParameter("deadlineDate") : "" %>" required>
        </div>
        <button type="submit" class="btn-success">Create Task</button>
    </form>
</div>