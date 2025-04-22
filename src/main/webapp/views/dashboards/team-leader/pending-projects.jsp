
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project"%>
<h1>Pending Projects</h1>
<div class="project-list-container">
    <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'"><i class="fas fa-arrow-left"></i> Back</button>
    <table class="table-modern">
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
                    <td><%=project.getProjectName()%></td>
                    <td><%=project.getDescription() != null ? project.getDescription() : "N/A"%></td>
                    <td><%=project.getStatus()%></td>
                    <td><%=project.getPriority() != null ? project.getPriority() : "N/A"%></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=pending-projects&projectId=<%=project.getProjectId()%>" class="view-btn">View</a>
                    </td>
                </tr>
            <% 
                    }
                } else {
            %>
                <tr><td colspan="5">No pending projects found.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>
