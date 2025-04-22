
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task"%>
<h1>Pending Tasks</h1>
<button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'"><i class="fas fa-arrow-left"></i> Back</button>

<% String errorMessage = (String) request.getAttribute("errorMessage"); %>
<% if (errorMessage != null) { %>
    <div class="alert alert-error"><%= errorMessage %></div>
<% } %>

<div class="tasks-container">
    <% List<Task> pendingTasks = (List<Task>) request.getAttribute("pendingTasks"); %>
    <% if (pendingTasks != null && !pendingTasks.isEmpty()) { %>
        <table class="table-modern">
            <thead>
                <tr>
                    <th>Task Title</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>Deadline</th>
                    <th>Assigned To</th>
                </tr>
            </thead>
            <tbody>
                <% for (Task task : pendingTasks) { %>
                    <tr>
                        <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
                        <td><%= task.getDescription() != null ? task.getDescription() : "N/A" %></td>
                        <td><%= task.getStatus() != null ? task.getStatus() : "N/A" %></td>
                        <td><%= task.getDeadlineDate() != null ? task.getDeadlineDate() : "N/A" %></td>
                        <td><%= task.getAssignedToEmployeeId() != null ? "Employee ID: " + task.getAssignedToEmployeeId() : "Unassigned" %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p>No pending tasks found.</p>
    <% } %>
</div>
