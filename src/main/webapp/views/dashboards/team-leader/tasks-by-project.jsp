<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task, in.efficio.model.Project, in.efficio.model.Employee, java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tasks for Project | Efficio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/teamleader/team-member.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
<div class="employee-list-container">
    <h1><i class="fas fa-tasks"></i> Tasks for Project</h1>
    <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'">
        <i class="fas fa-arrow-left"></i> Back
    </button>
    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        Project selectedProject = (Project) request.getAttribute("selectedProject");
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
    %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= errorMessage %></div>
    <% } %>
    <% if (selectedProject != null) { %>
        <h2><%= selectedProject.getProjectName() != null ? selectedProject.getProjectName() : "N/A" %></h2>
        <%
            List<Task> tasks = (List<Task>) request.getAttribute("tasks");
            List<Employee> teamMembers = (List<Employee>) request.getAttribute("teamMembers");
        %>
        <div class="table-wrapper">
            <% if (tasks != null && !tasks.isEmpty()) { %>
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th>Task Title</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Deadline</th>
                            <th>Progress (%)</th>
                            <th>Assigned To</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Task task : tasks) {
                                if (task == null || task.getTaskId() == null) continue;
                        %>
                            <tr>
                                <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
                                <td><%= task.getDescription() != null ? task.getDescription() : "N/A" %></td>
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
                                <td><%= task.getProgressPercentage() != null ? task.getProgressPercentage() : 0 %></td>
                                <td>
                                    <% 
                                        String assignedTo = "Unassigned";
                                        if (task.getAssignedToEmployeeId() != null && teamMembers != null) {
                                            for (Employee emp : teamMembers) {
                                                if (emp != null && task.getAssignedToEmployeeId().equals(emp.getEmployee_id())) {
                                                    assignedTo = emp.getName() != null ? emp.getName() : "ID: " + emp.getEmployee_id();
                                                    break;
                                                }
                                            }
                                        }
                                    %>
                                    <%= assignedTo %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p class="no-data"><i class="fas fa-exclamation-circle"></i> No tasks found for this project.</p>
            <% } %>
        </div>
    <% } else { %>
        <p class="no-data"><i class="fas fa-exclamation-circle"></i> No project selected.</p>
    <% } %>
</div>
</body>
</html>