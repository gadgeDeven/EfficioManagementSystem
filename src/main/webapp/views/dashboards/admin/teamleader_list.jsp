<%@ page import="java.util.List" %>
<%@ page import="in.efficio.model.TeamLeader" %>
<%@ page import="in.efficio.model.Project" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Team Leaders</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/lists.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
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
                        <th><i class="fas fa-id-badge"></i> ID</th>
                        <th><i class="fas fa-user"></i> Name</th>
                        <th><i class="fas fa-envelope"></i> Email</th>
                        <th><i class="fas fa-building"></i> Department</th>
                        <th><i class="fas fa-project-diagram"></i> Projects</th>
                        <th><i class="fas fa-eye"></i> Profile</th>
                    </tr>
                    <% for (TeamLeader tl : teamLeaders) { %>
                        <tr>
                            <td><%= tl.getTeamleader_id() %></td>
                            <td><%= tl.getName() != null ? tl.getName() : "N/A" %></td>
                            <td><%= tl.getEmail() != null ? tl.getEmail() : "N/A" %></td>
                            <td><%= tl.getDepartment_name() != null ? tl.getDepartment_name() : "N/A" %></td>
                            <td>
                                <% 
                                    List<Project> projects = tl.getProjects();
                                    if (projects != null && !projects.isEmpty()) {
                                        for (int i = 0; i < projects.size(); i++) {
                                            Project project = projects.get(i);
                                %>
                                            <a href="${pageContext.request.contextPath}/Projects?contentType=view-projects&action=view&projectId=<%= project.getProjectId() %>" class="plain-link"><%= project.getProjectId() %></a>
                                            <%= i < projects.size() - 1 ? ", " : "" %>
                                <% 
                                        }
                                    } else {
                                        out.print("None");
                                    }
                                %>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/TeamLeaders?id=<%= tl.getTeamleader_id() %>&contentType=teamleader-profile" class="view-btn">
                                    Profile
                                </a>
                            </td>
                        </tr>
                    <% } %>
                </table>
            </div>
        <% } else { %>
            <p class="no-data"><i class="fas fa-exclamation-circle"></i> No team leaders found.</p>
        <% } %>
    </div>
    <script src="${pageContext.request.contextPath}/views/assets/js/admin/employee_list.js"></script>
</body>
</html>