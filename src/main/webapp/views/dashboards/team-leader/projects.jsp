<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Projects</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/lists.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/view-projects.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="proj-list-container">
    <h1>
        <% String contentType = request.getParameter("contentType"); %>
        <%= "pending-projects".equals(contentType) ? "Pending Projects" : "completed-projects".equals(contentType) ? "Completed Projects" : "My Projects" %>
    </h1>
    <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'"><i class="fas fa-arrow-left"></i> Back to Dashboard</button>

    <!-- Messages -->
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
        <div class="alert"><%= errorMessage %></div>
    <% } %>

    <!-- Project Details or List -->
    <% Project selectedProject = (Project) request.getAttribute("selectedProject"); %>
    <% if (selectedProject != null) { %>
        <div class="proj-details">
            <div class="proj-details-grid">
                <p><strong>Name:</strong> <%= selectedProject.getProjectName() %></p>
                <p><strong>ID:</strong> <%= selectedProject.getProjectId() %></p>
                <p class="proj-description"><strong>Description:</strong> <%= selectedProject.getDescription() != null ? selectedProject.getDescription() : "N/A" %></p>
                <p><strong>Status:</strong> <%= selectedProject.getStatus() != null ? selectedProject.getStatus() : "N/A" %></p>
                <p><strong>Start Date:</strong> <%= selectedProject.getStartDate() != null ? selectedProject.getStartDate() : "N/A" %></p>
                <p><strong>End Date:</strong> <%= selectedProject.getEndDate() != null ? selectedProject.getEndDate() : "N/A" %></p>
                <p><strong>Priority:</strong> <%= selectedProject.getPriority() != null ? selectedProject.getPriority() : "N/A" %></p>
            </div>
            <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=<%= contentType %>'"><i class="fas fa-arrow-left"></i> Back to Projects</button>
        </div>
    <% } else { %>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Status</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
                <% if (projects != null && !projects.isEmpty()) { %>
                    <% for (Project project : projects) { %>
                        <tr>
                            <td><%= project.getProjectId() %></td>
                            <td><%= project.getProjectName() %></td>
                            <td><%= project.getStatus() != null ? project.getStatus() : "N/A" %></td>
                            <td><%= project.getStartDate() != null ? project.getStartDate() : "N/A" %></td>
                            <td><%= project.getEndDate() != null ? project.getEndDate() : "N/A" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=<%= contentType %>&projectId=<%= project.getProjectId() %>" class="proj-btn">View Details</a>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr><td colspan="6"><p class="no-data">No projects found.</p></td></tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>
</body>
</html>