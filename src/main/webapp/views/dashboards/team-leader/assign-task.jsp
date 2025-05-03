<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project, in.efficio.model.Task, in.efficio.model.Employee"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assign Task | Efficio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/teamleader/assign-task.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
<div class="progress-update-container">
    <h1><i class="fas fa-user-check"></i> Assign Task</h1>
    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        String employeeErrorMessage = (String) request.getAttribute("employeeErrorMessage");
        String successMessage = (String) request.getAttribute("successMessage");
    %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= errorMessage %></div>
    <% } %>
    <% if (employeeErrorMessage != null) { %>
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= employeeErrorMessage %></div>
    <% } %>
    <% if (successMessage != null) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= successMessage %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/TeamLeaderTaskServlet" method="get" class="form-group">
        <input type="hidden" name="contentType" value="assign-task">
        <label for="projectId"><i class="fas fa-project-diagram"></i> Select Project:</label>
        <select name="projectId" id="projectId" onchange="this.form.submit()" required>
            <option value="">Select Project</option>
            <% 
                List<Project> projects = (List<Project>) request.getAttribute("projects"); 
                String selectedProjectId = (String) request.getAttribute("selectedProjectId");
                if (projects != null && !projects.isEmpty()) { 
                    for (Project project : projects) { 
                        if (project != null) {
                            String selected = selectedProjectId != null && selectedProjectId.equals(String.valueOf(project.getProjectId())) ? "selected" : "";
            %>
                            <option value="<%= project.getProjectId() %>" <%= selected %>>
                                <%= project.getProjectName() != null ? project.getProjectName() : "N/A" %>
                            </option>
            <% 
                        }
                    } 
                } else { 
            %>
                    <option value="" disabled>No projects available</option>
            <% } %>
        </select>
    </form>

    <% if (selectedProjectId != null && !selectedProjectId.isEmpty()) { %>
        <%
            List<Task> tasks = (List<Task>) request.getAttribute("tasks");
            List<Employee> teamMembers = (List<Employee>) request.getAttribute("teamMembers");
        %>
        <h2>Tasks for Selected Project</h2>
        <div class="table-wrapper">
            <% if (tasks != null && !tasks.isEmpty()) { %>
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th>Task Title</th>
                            <th>Assigned To</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Task task : tasks) { %>
                            <% 
                                if (task == null) {
                                    System.out.println("Task is null in assign-task.jsp");
                                    continue;
                                }
                                Integer taskId = null;
                                try {
                                    taskId = task.getTaskId();
                                    if (taskId == null) {
                                        System.out.println("Task ID is null for task: " + task.getTaskTitle());
                                        continue;
                                    }
                                } catch (Exception e) {
                                    System.out.println("Error accessing getTaskId() for task: " + task.getTaskTitle() + ", Error: " + e.getMessage());
                                    continue;
                                }
                            %>
                            <tr>
                                <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
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
                                <td>
                                    <form action="${pageContext.request.contextPath}/TeamLeaderTaskServlet" method="post">
                                        <input type="hidden" name="action" value="assignTask">
                                        <input type="hidden" name="taskId" value="<%= taskId %>">
                                        <input type="hidden" name="projectId" value="<%= selectedProjectId %>">
                                        <input type="hidden" name="contentType" value="assign-task">
                                        <select name="employeeId" required>
                                            <option value="">Select Employee</option>
                                            <% 
                                                if (teamMembers != null && !teamMembers.isEmpty()) { 
                                                    for (Employee emp : teamMembers) { 
                                                        if (emp != null) {
                                                            String selected = task.getAssignedToEmployeeId() != null && task.getAssignedToEmployeeId().equals(emp.getEmployee_id()) ? "selected" : "";
                                            %>
                                                            <option value="<%= emp.getEmployee_id() %>" <%= selected %>>
                                                                <%= emp.getName() != null ? emp.getName() : "ID: " + emp.getEmployee_id() %>
                                                            </option>
                                            <% 
                                                        }
                                                    } 
                                                } else { 
                                            %>
                                                    <option value="" disabled>No employees assigned to this project</option>
                                            <% } %>
                                        </select>
                                        <button type="submit" class="btn-success" <%= teamMembers == null || teamMembers.isEmpty() ? "disabled" : "" %>>
                                            <i class="fas fa-user-check"></i> Assign
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p class="no-data"><i class="fas fa-exclamation-circle"></i> No tasks found for this project.</p>
            <% } %>
        </div>
    <% } %>
</div>
</body>
</html>