<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project, in.efficio.model.TeamLeader, in.efficio.model.Employee"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <%= "pending-projects".equals(request.getParameter("contentType")) ? "Pending Projects" :
            "completed-projects".equals(request.getParameter("contentType")) ? "Completed Projects" :
            "Projects" %>
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/lists.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/view-projects.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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
            List<TeamLeader> teamLeaders = (List<TeamLeader>) request.getAttribute("teamLeaders");
            List<Employee> employees = (List<Employee>) request.getAttribute("employees");
            Integer progress = (Integer) request.getAttribute("progress");
        %>
        <% if (project == null) { %>
            <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> Project not found.</p>
        <% } else { %>
            <div class="proj-details">
                <div class="proj-header">
                    <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=<%= contentType %>'"><i class="fas fa-arrow-left"></i> Back</button>
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
                </div>
                <h3><i class="fas fa-user-tie"></i> Team Leaders</h3>
                <div class="proj-team-list">
                    <% if (teamLeaders != null && !teamLeaders.isEmpty()) { %>
                        <% for (TeamLeader tl : teamLeaders) { %>
                            <div class="proj-team-item">
                                <%= tl.getName() != null ? tl.getName() : "N/A" %>
                            </div>
                        <% } %>
                    <% } else { %>
                        <p class="proj-no-data">No team leaders assigned.</p>
                    <% } %>
                </div>
                <h3><i class="fas fa-users"></i> Employees</h3>
                <div class="proj-employee-list">
                    <% if (employees != null && !employees.isEmpty()) { %>
                        <% for (Employee emp : employees) { %>
                            <div class="proj-employee-item">
                                <a href="${pageContext.request.contextPath}/TeamLeaderTeamServlet?contentType=employee-details&action=view&employeeId=<%= emp.getEmployee_id() %>">
                                    <%= emp.getName() != null ? emp.getName() : "N/A" %>
                                </a>
                            </div>
                        <% } %>
                    <% } else { %>
                        <p class="proj-no-data">No employees assigned.</p>
                    <% } %>
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
                                <a href="${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=<%= contentType %>&action=view&projectId=<%= project.getProjectId() %>" class="proj-btn"><i class="fas fa-eye"></i> View</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> 
                <%= "pending-projects".equals(contentType) ? "No pending projects found." :
                    "completed-projects".equals(contentType) ? "No completed projects found." :
                    "No projects found." %>
            </p>
        <% } %>
    <% } %>
</div>
</body>
</html>