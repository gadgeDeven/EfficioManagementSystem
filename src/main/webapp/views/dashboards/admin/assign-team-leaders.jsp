<%@ page import="java.util.List" %>
<%@ page import="in.efficio.model.Project" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Assign Team Leaders</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/assign-team-leaders.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <div class="container">
        <% 
            String error = (String) session.getAttribute("error");
            String message = (String) session.getAttribute("message");
            if (error != null) { 
        %>
            <div class="message-box error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
        <% 
                session.removeAttribute("error");
            } 
            if (message != null) { 
        %>
            <div class="message-box success"><i class="fas fa-check-circle"></i> <%= message %></div>
        <% 
                session.removeAttribute("message");
            } 
        %>

        <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
        <% if (projects != null && !projects.isEmpty()) { %>
            <table class="project-table">
                <thead>
                    <tr>
                        <th><i class="fas fa-id-badge"></i> ID</th>
                        <th><i class="fas fa-project-diagram"></i> Project Name</th>
                        <th><i class="fas fa-info-circle"></i> Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Project project : projects) { %>
                        <tr>
                            <td><%= project.getProjectId() %></td>
                            <td><%= project.getProjectName() %></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/Projects" method="get" style="display:inline;">
                                    <input type="hidden" name="action" value="viewProjectTeamLeaders">
                                    <input type="hidden" name="contentType" value="project-team-leaders">
                                    <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                                    <button type="submit" class="btn btn-view">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p><i class="fas fa-exclamation-circle"></i> No projects available to assign.</p>
        <% } %>
    </div>
</body>
</html>