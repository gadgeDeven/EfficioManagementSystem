<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task, in.efficio.model.Project, in.efficio.model.Employee"%>
<h1>Tasks for Project</h1>
<button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=assign-projects'"><i class="fas fa-arrow-left"></i> Back</button>
<div class="tasks-by-project-container">
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% Project selectedProject = (Project) request.getAttribute("selectedProject"); %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>
    <% if (selectedProject != null) { %>
        <h2><%= selectedProject.getProjectName() %></h2>
        <% List<Task> tasks = (List<Task>) request.getAttribute("tasks"); %>
        <% List<Employee> teamMembers = (List<Employee>) request.getAttribute("teamMembers"); %>
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
                    <% for (Task task : tasks) { %>
                        <tr>
                            <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
                            <td><%= task.getDescription() != null ? task.getDescription() : "N/A" %></td>
                            <td><%= task.getStatus() != null ? task.getStatus() : "N/A" %></td>
                            <td><%= task.getDeadlineDate() != null ? task.getDeadlineDate() : "N/A" %></td>
                            <td><%= task.getProgressPercentage() %></td>
                            <td>
                                <% 
                                    String assignedTo = "Unassigned";
                                    if (task.getAssignedToEmployeeId() != null && teamMembers != null) {
                                        for (Employee emp : teamMembers) {
                                            if (emp.getEmployee_id() == task.getAssignedToEmployeeId()) {
                                                assignedTo = emp.getName();
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
            <p>No tasks found for this project.</p>
        <% } %>
    <% } else { %>
        <p>No project selected.</p>
    <% } %>
</div>