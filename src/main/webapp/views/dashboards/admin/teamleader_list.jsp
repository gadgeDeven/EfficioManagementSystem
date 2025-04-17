<%@ page import="java.util.List" %>
<%@ page import="in.efficio.model.TeamLeader" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Team Leaders</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/employee_list.css">
</head>
<body>
    <h3 class="total-employees">Total Team Leaders: 
        <% 
            Integer tlCount = (Integer) request.getAttribute("teamLeaderCount");
            out.print(tlCount != null ? tlCount : "No data found");
        %>
    </h3>

    <div class="employee-list-container">
        <% List<TeamLeader> teamLeaders = (List<TeamLeader>) request.getAttribute("teamLeaders"); %>
        <% if ("view-teamleaders".equals(request.getAttribute("contentType")) && teamLeaders != null && !teamLeaders.isEmpty()) { %>
            <div class="table-wrapper">
                <table>
                    <tr id="heading">
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Department</th>
                        <th>Project</th>
                        <th>Profile</th>
                    </tr>
                    <% for (TeamLeader tl : teamLeaders) { %>
                        <tr>
                            <td><%= tl.getTeamleader_id() %></td>
                            <td><%= tl.getName() %></td>
                            <td><%= tl.getEmail() %></td>
                            <td><%= tl.getDepartment_name() %></td>
                            <td><%= tl.getAssign_project_name() %></td>
                            <td><a href="${pageContext.request.contextPath}/TeamLeaders?id=<%= tl.getTeamleader_id() %>&contentType=teamleader-profile">Profile</a></td>
                        </tr>
                    <% } %>
                </table>
            </div>
        <% } else { %>
            <p class="no-data">No team leaders found.</p>
        <% } %>
    </div>
</body>
</html>