<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project, in.efficio.model.Task, in.efficio.model.Employee"%>
<h1>Assign Task</h1>
<button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=tasks'"><i class="fas fa-arrow-left"></i> Back</button>
<div class="assign-task-container">
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% String employeeErrorMessage = (String) request.getAttribute("employeeErrorMessage"); %>
    <% String successMessage = (String) request.getAttribute("successMessage"); %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>
    <% if (employeeErrorMessage != null) { %>
        <div class="alert alert-error"><%= employeeErrorMessage %></div>
    <% } %>
    <% if (successMessage != null) { %>
        <div class="alert alert-success"><%= successMessage %></div>
    <% } %>

    <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
    <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="get">
        <input type="hidden" name="contentType" value="assign-task">
        <div class="form-group">
            <label for="projectId">Select Project:</label>
            <select name="projectId" id="projectId" onchange="this.form.submit()">
                <option value="">Select Project</option>
                <% if (projects != null && !projects.isEmpty()) { %>
                    <% for (Project project : projects) { %>
                        <option value="<%= project.getProjectId() %>"
                            <%= request.getParameter("projectId") != null && request.getParameter("projectId").equals(String.valueOf(project.getProjectId())) ? "selected" : "" %>>
                            <%= project.getProjectName() %>
                        </option>
                    <% } %>
                <% } else { %>
                    <option value="" disabled>No projects available</option>
                <% } %>
            </select>
        </div>
    </form>

    <% String selectedProjectId = request.getParameter("projectId"); %>
    <% if (selectedProjectId != null && !selectedProjectId.isEmpty()) { %>
        <% List<Task> tasks = (List<Task>) request.getAttribute("tasks"); %>
        <% List<Employee> teamMembers = (List<Employee>) request.getAttribute("teamMembers"); %>
        <h2>Tasks for Selected Project</h2>
        <table class="table-modern">
            <thead>
                <tr>
                    <th>Task Title</th>
                    <th>Assigned To</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% if (tasks != null && !tasks.isEmpty()) { %>
                    <% for (Task task : tasks) { %>
                        <tr>
                            <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
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
                            <td>
                                <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="post">
                                    <input type="hidden" name="action" value="assignTask">
                                    <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                    <input type="hidden" name="projectId" value="<%= selectedProjectId %>">
                                    <select name="employeeId" required>
                                        <option value="">Select Employee</option>
                                        <% if (teamMembers != null && !teamMembers.isEmpty()) { %>
                                            <% for (Employee emp : teamMembers) { %>
                                                <option value="<%= emp.getEmployee_id() %>"
                                                    <%= task.getAssignedToEmployeeId() != null && task.getAssignedToEmployeeId() == emp.getEmployee_id() ? "selected" : "" %>>
                                                    <%= emp.getName() %>
                                                </option>
                                            <% } %>
                                        <% } else { %>
                                            <option value="" disabled>No employees assigned to this project</option>
                                        <% } %>
                                    </select>
                                    <button type="submit" class="btn-success" <%= teamMembers == null || teamMembers.isEmpty() ? "disabled" : "" %>>Assign</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr><td colspan="3">No tasks found for this project.</td></tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>