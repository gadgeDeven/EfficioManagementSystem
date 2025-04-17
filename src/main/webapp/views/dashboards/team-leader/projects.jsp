<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project"%>

<div class="container">
    <h1>
        <% String contentType = request.getParameter("contentType"); %>
        <%= "pending-projects".equals(contentType) ? "Pending Projects" : "completed-projects".equals(contentType) ? "Completed Projects" : "My Projects" %>
    </h1>
    <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'">Back to Dashboard</button>

    <!-- Messages -->
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>

    <!-- Project Details or List -->
    <% Project selectedProject = (Project) request.getAttribute("selectedProject"); %>
    <% if (selectedProject != null) { %>
        <div class="project-details">
            <h3><%= selectedProject.getProjectName() %></h3>
            <p><strong>ID:</strong> <%= selectedProject.getProjectId() %></p>
            <p><strong>Description:</strong> <%= selectedProject.getDescription() != null ? selectedProject.getDescription() : "N/A" %></p>
            <p><strong>Status:</strong> <%= selectedProject.getStatus() != null ? selectedProject.getStatus() : "N/A" %></p>
            <p><strong>Start Date:</strong> <%= selectedProject.getStartDate() != null ? selectedProject.getStartDate() : "N/A" %></p>
            <p><strong>End Date:</strong> <%= selectedProject.getEndDate() != null ? selectedProject.getEndDate() : "N/A" %></p>
            <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=<%= contentType %>'">Back to Projects</button>
        </div>
    <% } else { %>
        <h3>All <%= "pending-projects".equals(contentType) ? "Pending" : "completed-projects".equals(contentType) ? "Completed" : "" %> Projects</h3>
        <table class="table-modern">
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
                                <a href="${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=<%= contentType %>&projectId=<%= project.getProjectId() %>" class="view-btn">View Details</a>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr><td colspan="6">No projects found.</td></tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>