<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project, in.efficio.model.Employee"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Projects</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/teamleader/assign-projects.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <div class="container">
        <!-- Messages -->
        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
        <% String successMessage = (String) request.getAttribute("successMessage"); %>
        <% if (errorMessage != null) { %>
            <div class="alert alert-error"><%= errorMessage %></div>
        <% } %>
        <% if (successMessage != null) { %>
            <div class="alert alert-success"><%= successMessage %></div>
        <% } %>

        <!-- Project Selection -->
        <div class="project-selection">
            <h2>Select Project</h2>
            <form action="${pageContext.request.contextPath}/TeamLeaderProjectServlet" method="get">
                <input type="hidden" name="contentType" value="assign-projects">
                <label for="projectId">Project:</label>
                <select name="projectId" id="projectId" onchange="this.form.submit()">
                    <option value="">-- Select Project --</option>
                    <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
                    <% if (projects != null) { %>
                        <% for (Project project : projects) { %>
                            <option value="<%= project.getProjectId() %>" <%= request.getParameter("projectId") != null && request.getParameter("projectId").equals(String.valueOf(project.getProjectId())) ? "selected" : "" %>>
                                <%= project.getProjectName() %>
                            </option>
                        <% } %>
                    <% } %>
                </select>
            </form>
        </div>

        <!-- Project Details -->
        <% Project selectedProject = (Project) request.getAttribute("selectedProject"); %>
        <% if (selectedProject != null) { %>
            <div class="project-details">
                <h3><%= selectedProject.getProjectName() %></h3>
                <div class="details-grid">
                    <div class="detail-item">
                        <span class="detail-label id">ID</span>
                        <span class="detail-value"><%= selectedProject.getProjectId() %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label status">Status</span>
                        <span class="detail-value"><%= selectedProject.getStatus() != null ? selectedProject.getStatus() : "N/A" %></span>
                    </div>
                    <div class="detail-item full-width">
                        <span class="detail-label description">Description</span>
                        <span class="detail-value"><%= selectedProject.getDescription() != null ? selectedProject.getDescription() : "N/A" %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label start-date">Start Date</span>
                        <span class="detail-value"><%= selectedProject.getStartDate() != null ? selectedProject.getStartDate() : "N/A" %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label end-date">End Date</span>
                        <span class="detail-value"><%= selectedProject.getEndDate() != null ? selectedProject.getEndDate() : "N/A" %></span>
                    </div>
                </div>
            </div>

            <!-- Employees List -->
            <h3 class="assign-employees-heading">Assign Employees to <%= selectedProject.getProjectName() %></h3>
            <table class="table-modern">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Department</th>
                        <th>Status</th>
                        <th>Action</th>
                        <th>View</th>
                    </tr>
                </thead>
                <tbody>
                    <% List<Employee> allEmployees = (List<Employee>) request.getAttribute("allEmployees"); %>
                    <% List<Employee> assignedEmployees = (List<Employee>) request.getAttribute("assignedEmployees"); %>
                    <% if (allEmployees != null && !allEmployees.isEmpty()) { %>
                        <% for (Employee employee : allEmployees) { %>
                            <tr>
                                <td><%= employee.getName() %></td>
                                <td><%= employee.getEmail() %></td>
                                <td><%= employee.getDept_name() != null ? employee.getDept_name() : "N/A" %></td>
                                <td>
                                    <% boolean isAssigned = assignedEmployees != null && assignedEmployees.stream().anyMatch(e -> e.getEmployee_id() == employee.getEmployee_id()); %>
                                    <%= isAssigned ? "Assigned" : "Not Assigned" %>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/TeamLeaderProjectServlet" method="post">
                                        <input type="hidden" name="action" value="assignEmployee">
                                        <input type="hidden" name="projectId" value="<%= selectedProject.getProjectId() %>">
                                        <input type="hidden" name="employeeId" value="<%= employee.getEmployee_id() %>">
                                        <% if (isAssigned) { %>
                                            <input type="hidden" name="assign" value="remove">
                                            <button type="submit" class="action-btn remove-btn">Remove</button>
                                        <% } else { %>
                                            <input type="hidden" name="assign" value="add">
                                            <button type="submit" class="action-btn assign-btn">Assign</button>
                                        <% } %>
                                    </form>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=employee-details&employeeId=<%= employee.getEmployee_id() %>&projectId=<%= selectedProject.getProjectId() %>" class="action-btn view-btn">View</a>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr><td colspan="6">No employees available.</td></tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p style="text-align: center;">Please select a project to view details and assign employees.</p>
        <% } %>
    </div>
</body>
</html>