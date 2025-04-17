<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task, in.efficio.model.Project"%>
<h1>Tasks</h1>
<button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'"><i class="fas fa-arrow-left"></i> Back</button>

<% String successMessage = (String) request.getAttribute("successMessage"); %>
<% String errorMessage = (String) request.getAttribute("errorMessage"); %>
<% if (successMessage != null) { %>
    <div class="alert alert-success">
        <%= successMessage %>
    </div>
<% } %>
<% if (errorMessage != null) { %>
    <div class="alert alert-error">
        <%= errorMessage %>
    </div>
<% } %>

<div class="tasks-container">
    <% List<Task> tasks = (List<Task>) request.getAttribute("tasks"); %>
    <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
    <% if (tasks != null && !tasks.isEmpty()) { %>
        <table class="table-modern">
            <thead>
                <tr>
                    <th>Task Title</th>
                    <th>Project</th>
                    <th>Assigned To</th>
                    <th>Status</th>
                    <th>Deadline</th>
                </tr>
            </thead>
            <tbody>
                <% for (Task task : tasks) { %>
                    <tr>
                        <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
                        <td>
                            <% 
                                String projectName = "Unknown";
                                if (projects != null) {
                                    for (Project project : projects) {
                                        if (project.getProjectId() == task.getProjectId()) {
                                            projectName = project.getProjectName();
                                            break;
                                        }
                                    }
                                }
                            %>
                            <%= projectName %>
                        </td>
                        <td><%= task.getAssignedToEmployeeId() != null ? "Employee ID: " + task.getAssignedToEmployeeId() : "Unassigned" %></td>
                        <td><%= task.getStatus() != null ? task.getStatus() : "N/A" %></td>
                        <td><%= task.getDeadlineDate() != null ? task.getDeadlineDate() : "N/A" %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p>No tasks found.</p>
    <% } %>
</div>