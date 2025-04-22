<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pending Projects</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/lists.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/view-projects.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="proj-list-container">
    <h1>Pending Projects</h1>
    <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'"><i class="fas fa-arrow-left"></i> Back</button>
    <table>
        <thead>
            <tr>
                <th>Project Name</th>
                <th>Description</th>
                <th>Status</th>
                <th>Priority</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <% 
                List<Project> pendingProjects = (List<Project>) request.getAttribute("pendingProjects");
                if (pendingProjects != null && !pendingProjects.isEmpty()) {
                    for (Project project : pendingProjects) {
            %>
                <tr>
                    <td><%= project.getProjectName() %></td>
                    <td><%= project.getDescription() != null ? project.getDescription() : "N/A" %></td>
                    <td><%= project.getStatus() %></td>
                    <td><%= project.getPriority() != null ? project.getPriority() : "N/A" %></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=pending-projects&projectId=<%= project.getProjectId() %>" class="proj-btn">View</a>
                    </td>
                </tr>
            <% 
                    }
                } else {
            %>
                <tr><td colspan="5"><p class="no-data">No pending projects found.</p></td></tr>
            <% } %>
        </tbody>
    </table>
</div>
</body>
</html>