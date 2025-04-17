<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="in.efficio.model.Project" %>
<%@ page import="in.efficio.model.TeamLeader" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Assign Team Leaders</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/assign-team-leaders.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <div class="assign-team-leader-container">
        <% 
            String error = (String) session.getAttribute("error");
            String message = (String) session.getAttribute("message");
            if (error != null) { 
        %>
            <p class="error-message"><i class="fas fa-exclamation-circle"></i> <%= error %></p>
        <% 
                session.removeAttribute("error");
            } 
            if (message != null) { 
        %>
            <p class="success-message"><i class="fas fa-check-circle"></i> <%= message %></p>
        <% 
                session.removeAttribute("message");
            } 
        %>
        <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
        <% Map<Integer, List<TeamLeader>> assignedTeamLeadersMap = (Map<Integer, List<TeamLeader>>) request.getAttribute("assignedTeamLeadersMap"); %>
        <% if (projects != null && !projects.isEmpty()) { %>
            <table>
                <tr>
                    <th><i class="fas fa-id-badge"></i> ID</th>
                    <th><i class="fas fa-project-diagram"></i> Project Name</th>
                    <th><i class="fas fa-user-tie"></i> Assigned Team Leaders</th>
                    <th><i class="fas fa-plus"></i> Assign Team Leader</th>
                </tr>
                <% for (Project project : projects) { %>
                    <tr>
                        <td><%= project.getProjectId() %></td>
                        <td><%= project.getProjectName() %></td>
                        <td>
                            <ul class="assigned-list">
                                <% List<TeamLeader> assignedTLs = assignedTeamLeadersMap.get(project.getProjectId()); %>
                                <% if (assignedTLs != null && !assignedTLs.isEmpty()) { %>
                                    <% for (TeamLeader tl : assignedTLs) { %>
                                        <li>
                                            <%= tl.getName() %>
                                            <form action="${pageContext.request.contextPath}/Projects" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="removeTeamLeader">
                                                <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                                                <input type="hidden" name="teamLeaderId" value="<%= tl.getTeamleader_id() %>">
                                                <button type="submit" class="remove-btn"><i class="fas fa-times"></i></button>
                                            </form>
                                        </li>
                                    <% } %>
                                <% } else { %>
                                    <li>No team leaders assigned yet.</li>
                                <% } %>
                            </ul>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/Projects" method="post">
                                <input type="hidden" name="action" value="assignTeamLeader">
                                <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                                <select name="teamLeaderId" class="team-leader-select" required>
                                    <option value="">Select Team Leader</option>
                                    <% List<TeamLeader> teamLeaders = (List<TeamLeader>) request.getAttribute("teamLeaders"); %>
                                    <% if (teamLeaders != null) { %>
                                        <% for (TeamLeader tl : teamLeaders) { %>
                                            <option value="<%= tl.getTeamleader_id() %>"><%= tl.getName() %></option>
                                        <% } %>
                                    <% } %>
                                </select>
                                <button type="submit" class="btn"><i class="fas fa-plus"></i> Assign</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
            </table>
        <% } else { %>
            <p><i class="fas fa-exclamation-circle"></i> No projects available to assign.</p>
        <% } %>
    </div>
</body>
</html>