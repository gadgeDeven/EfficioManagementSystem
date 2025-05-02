<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project, in.efficio.model.Employee"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Projects</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/lists.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/view-projects.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        .team-section { margin-top: 20px; }
        .team-section h3 { font-size: 1.2em; margin-bottom: 10px; }
        .team-table { width: 100%; border-collapse: collapse; }
        .team-table th, .team-table td { padding: 10px; border-bottom: 1px solid #ddd; }
        .team-table th { background-color: #f4f4f4; font-weight: bold; }
        .team-table tr:hover { background-color: #f9f9f9; }
        .employee-name { 
            font-weight: bold; 
            color: #2c3e50; 
            font-size: 1.1em; 
            text-transform: capitalize; 
            display: flex; 
            align-items: center; 
        }
        .employee-name i { 
            margin-right: 8px; 
            color: #3498db; 
        }
    </style>
</head>
<body>
<div class="proj-list-container">
    <% 
        String action = request.getParameter("action");
        String contentType = request.getParameter("contentType");
        if (contentType == null) contentType = "projects";
    %>

    <% if ("view".equals(action)) { %>
        <% 
            Project project = (Project) request.getAttribute("projectDetails");
            Integer progress = (Integer) request.getAttribute("progress");
            List<Employee> assignedEmployees = (List<Employee>) request.getAttribute("assignedEmployees");
        %>
        <% if (project == null) { %>
            <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> Project not found.</p>
        <% } else { %>
            <div class="proj-details">
                <div class="proj-header">
                    <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/EmployeeProjectServlet?contentType=projects'"><i class="fas fa-arrow-left"></i> Back</button>
                    <h1><i class="fas fa-project-diagram"></i> <%= project.getProjectName() != null ? project.getProjectName() : "N/A" %></h1>
                </div>
                <div class="proj-details-grid">
                    <p class="proj-description"><strong><i class="fas fa-info-circle"></i> Description:</strong> <%= project.getDescription() != null ? project.getDescription() : "N/A" %></p>
                    <div class="proj-date-status-grid">
                        <p><strong><i class="fas fa-calendar-alt"></i> Start Date:</strong> <%= project.getStartDate() != null ? project.getStartDate() : "N/A" %></p>
                        <p><strong><i class="fas fa-calendar-check"></i> End Date:</strong> <%= project.getEndDate() != null ? project.getEndDate() : "N/A" %></p>
                        <p><strong><i class="fas fa-tasks"></i> Status:</strong> <%= project.getStatus() != null ? project.getStatus() : "N/A" %></p>
                        <p><strong><i class="fas fa-exclamation-triangle"></i> Priority:</strong> <%= project.getPriority() != null ? project.getPriority() : "N/A" %></p>
                    </div>
                    <div class="proj-progress-bar">
                        <label><i class="fas fa-chart-line"></i> Progress:</label>
                        <div class="progress-container">
                            <div class="progress" style="width: <%= progress != null ? progress : 0 %>%;"></div>
                        </div>
                        <span><%= progress != null ? progress : 0 %>%</span>
                    </div>
                    <!-- Assigned Employees Section -->
                    <div class="team-section">
                        <h3><i class="fas fa-users"></i> Assigned Employees</h3>
                        <% if (assignedEmployees != null && !assignedEmployees.isEmpty()) { %>
                            <table class="team-table">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Mobile</th>
                                        <th>Department</th>
                                        <th>Assigned By</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Employee emp : assignedEmployees) { %>
                                        <tr>
                                            <td><span class="employee-name"><i class="fas fa-user"></i><%= emp.getName() != null ? emp.getName() : "N/A" %></span></td>
                                            <td><%= emp.getEmail() != null ? emp.getEmail() : "N/A" %></td>
                                            <td><%= emp.getMobile_number() != null ? emp.getMobile_number() : "N/A" %></td>
                                            <td><%= emp.getDept_name() != null ? emp.getDept_name() : "N/A" %></td>
                                            <td><%= emp.getTeamLeader_name() != null ? emp.getTeamLeader_name() : "N/A" %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } else { %>
                            <p>No employees assigned.</p>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } %>
    <% } else { %>
        <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
        <% if (projects != null && !projects.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-project-diagram"></i> Project Name</th>
                        <th><i class="fas fa-info-circle"></i> Description</th>
                        <th><i class="fas fa-tasks"></i> Status</th>
                        <th><i class="fas fa-exclamation-triangle"></i> Priority</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Project project : projects) { %>
                        <tr>
                            <td><%= project.getProjectName() != null ? project.getProjectName() : "N/A" %></td>
                            <td><%= project.getDescription() != null ? project.getDescription() : "N/A" %></td>
                            <td><%= project.getStatus() != null ? project.getStatus() : "N/A" %></td>
                            <td><%= project.getPriority() != null ? project.getPriority() : "N/A" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/EmployeeProjectServlet?contentType=projects&action=view&projectId=<%= project.getProjectId() %>" class="proj-btn"><i class="fas fa-eye"></i> View</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> No projects assigned.</p>
        <% } %>
    <% } %>
</div>
</body>
</html>