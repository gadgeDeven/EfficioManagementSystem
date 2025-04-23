<%@ page import="in.efficio.model.TeamLeader" %>
<%@ page import="in.efficio.model.Project" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Team Leader Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="profile-content">
        <%
            TeamLeader tl = (TeamLeader) request.getAttribute("teamLeader");
            String projectId = (String) request.getAttribute("projectId");
            String from = (String) request.getAttribute("from");
            String backUrl;
            if ("project-team-leaders".equals(from) && projectId != null) {
                backUrl = "${pageContext.request.contextPath}/Projects?contentType=project-team-leaders&projectId=" + projectId;
            } else if ("project-view".equals(from) && projectId != null) {
                backUrl = "${pageContext.request.contextPath}/Projects?contentType=view-projects&action=view&projectId=" + projectId;
            } else {
                backUrl = "${pageContext.request.contextPath}/TeamLeaders?contentType=view-teamleaders";
            }
        %>
        <% if (tl != null) { %>
            <div class="profile-details">
                <div class="profile-details-content">
                    <p><strong><i class="fas fa-user"></i> Name:</strong> <%= tl.getName() != null ? tl.getName() : "N/A" %></p>
                    <p><strong><i class="fas fa-id-badge"></i> ID:</strong> <%= tl.getTeamleader_id() %></p>
                    <p><strong><i class="fas fa-envelope"></i> Email:</strong> <%= tl.getEmail() != null ? tl.getEmail() : "N/A" %></p>
                    <p><strong><i class="fas fa-building"></i> Department:</strong> <%= tl.getDepartment_name() != null ? tl.getDepartment_name() : "N/A" %></p>
                    <p><strong><i class="fas fa-tools"></i> Skills:</strong> <%= tl.getSkills() != null ? tl.getSkills() : "N/A" %></p>
                    <p><strong><i class="fas fa-birthday-cake"></i> Date of Birth:</strong> <%= tl.getDob() != null ? tl.getDob() : "N/A" %></p>
                </div>
                <div class="profile-photo">
                    <span><i class="fas fa-user"></i> Photo</span>
                </div>
            </div>
            <table class="project-table">
                <tr id="projectandteamleader">
                    <th><i class="fas fa-hashtag"></i> Project No.</th>
                    <th><i class="fas fa-project-diagram"></i> Project Name</th>
                </tr>
                <% 
                    List<Project> projects = tl.getProjects();
                    if (projects != null && !projects.isEmpty()) {
                        for (Project project : projects) {
                %>
                            <tr>
                                <td><%= project.getProjectId() %></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/Projects?contentType=view-projects&action=view&projectId=<%= project.getProjectId() %>&from=teamleader-profile" class="plain-link">
                                        <%= project.getProjectName() != null ? project.getProjectName() : "Unknown Project" %>
                                    </a>
                                </td>
                            </tr>
                <% 
                        }
                    } else {
                %>
                        <tr>
                            <td>-</td>
                            <td>No projects assigned</td>
                        </tr>
                <% 
                    }
                %>
            </table>
            <form action="DeleteTeamLeader" method="post" onsubmit="return confirm('Are you sure you want to delete this team leader?');">
                <input type="hidden" name="id" value="<%= tl.getTeamleader_id() %>">
                <button type="submit" class="delete-btn"><i class="fas fa-trash"></i> Delete Team Leader</button>
            </form>
        <% } else { %>
            <p class="no-data"><i class="fas fa-exclamation-circle"></i> Team Leader data not found.</p>
        <% } %>
       
    </div>
    <script src="${pageContext.request.contextPath}/views/assets/js/admin/employee_list.js"></script>
</body>
</html>