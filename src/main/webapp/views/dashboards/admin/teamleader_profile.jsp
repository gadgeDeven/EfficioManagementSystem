<%@ page import="in.efficio.model.TeamLeader" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Team Leader Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/employee_profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

</head>
<body>
    <%
        TeamLeader tl = (TeamLeader) request.getAttribute("teamLeader");
        if (tl != null) {
    %>
        
        <div class="profile-content">
            <div class="profile-photo">
                <span><i class="fas fa-user"></i> Photo</span>
            </div>
            <div class="profile-details">
                <p><strong><i class="fas fa-user"></i> Name:</strong> <%= tl.getName() %></p>
                <p><strong><i class="fas fa-id-badge"></i> ID:</strong> <%= tl.getTeamleader_id() %></p>
                <p><strong><i class="fas fa-envelope"></i> Email:</strong> <%= tl.getEmail() %></p>
                <p><strong><i class="fas fa-building"></i> Department:</strong> <%= tl.getDepartment_name() %></p>
                <p><strong><i class="fas fa-tools"></i> Skills:</strong> <%= tl.getSkills() %></p>
                <p><strong><i class="fas fa-birthday-cake"></i> Date of Birth:</strong> <%= tl.getDob() %></p>

                <table class="project-table">
                    <tr id="projectandteamleader">
                        <th><i class="fas fa-project-diagram"></i> Project Name</th>
                    </tr>
                    <tr>
                        <td><%= tl.getAssign_project_name() %></td>
                    </tr>
                </table>

                <form action="DeleteTeamLeader" method="post" onsubmit="return confirm('Are you sure you want to delete this team leader?');">
                    <input type="hidden" name="id" value="<%= tl.getTeamleader_id() %>">
                    <button type="submit" class="delete-btn"><i class="fas fa-trash"></i> Delete Team Leader</button>
                </form>
            </div>
        </div>
    <%
        } else {
    %>
        <p class="no-data"><i class="fas fa-exclamation-circle"></i> Team Leader data not found.</p>
    <%
        }
    %>
    <script src="${pageContext.request.contextPath}/views/assets/js/admin/employee_list.js"></script>
</body>
</html>