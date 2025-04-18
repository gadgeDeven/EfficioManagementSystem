<%@ page import="in.efficio.model.Employee" %>
<%@ page import="in.efficio.model.Project" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Employee Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <%
        Employee emp = (Employee) request.getAttribute("employee");
        String referer = request.getHeader("Referer");
        String backUrl = (referer != null && !referer.isEmpty()) ? referer : "${pageContext.request.contextPath}/Employees?contentType=view-employees";
        if (emp != null) {
    %>
        <div class="profile-content">
            <div class="profile-details">
                <div class="profile-details-content">
                    <p><strong><i class="fas fa-user"></i> Name:</strong> <%= emp.getName() != null ? emp.getName() : "N/A" %></p>
                    <p><strong><i class="fas fa-id-badge"></i> ID:</strong> <%= emp.getEmployee_id() %></p>
                    <p><strong><i class="fas fa-envelope"></i> Email:</strong> <%= emp.getEmail() != null ? emp.getEmail() : "N/A" %></p>
                    <p><strong><i class="fas fa-building"></i> Department:</strong> <%= emp.getDept_name() != null ? emp.getDept_name() : "N/A" %></p>
                    <p><strong><i class="fas fa-tools"></i> Skills:</strong> <%= emp.getSkills() != null ? emp.getSkills() : "N/A" %></p>
                    <p><strong><i class="fas fa-star"></i> Rating:</strong> 
                        <span class="rating-stars">
                            <span style="width: <%= emp.getRating() * 20 %>%;"></span>
                        </span> (<%= emp.getRating() %>/5)
                    </p>
                    <p><strong><i class="fas fa-birthday-cake"></i> Date of Birth:</strong> <%= emp.getDob() != null ? emp.getDob() : "N/A" %></p>
                </div>
                <div class="profile-photo">
                    <span><i class="fas fa-user"></i> Photo</span>
                </div>
            </div>
            <table class="project-table">
                <tr id="projectandteamleader">
                    <th><i class="fas fa-hashtag"></i> Project No.</th>
                    <th><i class="fas fa-project-diagram"></i> Project Name</th>
                    <th><i class="fas fa-user-tie"></i> Team Leader</th>
                </tr>
                <% 
                    List<Project> projects = emp.getProjects();
                    if (projects != null && !projects.isEmpty()) {
                        for (Project project : projects) {
                %>
                            <tr>
                                <td><%= project.getProjectId() %></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/Projects?contentType=view-projects&action=view&projectId=<%= project.getProjectId() %>" class="plain-link">
                                        <%= project.getProjectName() != null ? project.getProjectName() : "Unknown Project" %>
                                    </a>
                                </td>
                                <td>
                                    <% if (project.getTeamLeaderName() != null) { %>
                                        <a href="${pageContext.request.contextPath}/TeamLeaders?id=<%= project.getTeamLeaderId() %>&contentType=teamleader-profile" class="plain-link">
                                            <%= project.getTeamLeaderName() %>
                                        </a>
                                    <% } else { %>
                                        None
                                    <% } %>
                                </td>
                            </tr>
                <% 
                        }
                    } else {
                %>
                        <tr>
                            <td>-</td>
                            <td>No projects assigned</td>
                            <td>None</td>
                        </tr>
                <% 
                    }
                %>
            </table>
            <form action="DeleteEmployee" method="post" onsubmit="return confirm('Are you sure you want to delete this employee?');">
                <input type="hidden" name="id" value="<%= emp.getEmployee_id() %>">
                <button type="submit" class="delete-btn"><i class="fas fa-trash"></i> Delete Employee</button>
            </form>
        </div>
    <%
        } else {
    %>
        <p class="no-data"><i class="fas fa-exclamation-circle"></i> Employee data not found.</p>
    <%
        }
    %>
    <script src="${pageContext.request.contextPath}/views/assets/js/admin/employee_list.js"></script>
</body>
</html>