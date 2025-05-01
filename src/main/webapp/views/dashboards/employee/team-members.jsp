<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Employee, in.efficio.model.Project"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Team Members</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/lists.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <div class="employee-list-container">
        <h2><i class="fas fa-users"></i> Team Members</h2>
        <% List<Employee> teamMembers = (List<Employee>) request.getAttribute("teamMembers"); %>
        <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
        <% String selectedProjectId = (String) request.getAttribute("selectedProjectId"); %>

        <!-- Project Filter Dropdown -->
        <div class="filter-container">
            <form action="${pageContext.request.contextPath}/EmployeeTeamServlet" method="get">
                <input type="hidden" name="contentType" value="team-members">
                <select name="filterProjectId" onchange="this.form.submit()">
                    <option value="">All Projects</option>
                    <% if (projects != null && !projects.isEmpty()) { %>
                        <% for (Project project : projects) { %>
                            <option value="<%= project.getProjectId() %>" 
                                    <%= (selectedProjectId != null && selectedProjectId.equals(String.valueOf(project.getProjectId()))) ? "selected" : "" %>>
                                <%= project.getProjectName() != null ? project.getProjectName() : "N/A" %>
                            </option>
                        <% } %>
                    <% } %>
                </select>
            </form>
        </div>

        <% if (teamMembers != null && !teamMembers.isEmpty()) { %>
            <div class="table-wrapper">
                <table class="team-table">
                    <thead id="heading">
                        <tr>
                            <th><i class="fas fa-user"></i> Name</th>
                            <th><i class="fas fa-envelope"></i> Email</th>
                            <th><i class="fas fa-phone"></i> Mobile</th>
                            <th><i class="fas fa-building"></i> Department</th>
                            <th><i class="fas fa-project-diagram"></i> Project</th>
                            <th><i class="fas fa-user-tie"></i> Assigned By</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Employee emp : teamMembers) { %>
                            <tr>
                                <td><span class="employee-name"><i class="fas fa-user"></i><%= emp.getName() != null ? emp.getName() : "N/A" %></span></td>
                                <td><%= emp.getEmail() != null ? emp.getEmail() : "N/A" %></td>
                                <td><%= emp.getMobileNumber() != null ? emp.getMobileNumber() : "N/A" %></td>
                                <td><%= emp.getDept_name() != null ? emp.getDept_name() : "N/A" %></td>
                                <td><%= emp.getAssign_project_name() != null ? emp.getAssign_project_name() : "N/A" %></td>
                                <td><%= emp.getTeamLeader_name() != null ? emp.getTeamLeader_name() : "N/A" %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <p class="total-employees"><i class="fas fa-users"></i> Total Team Members: <%= teamMembers.size() %></p>
        <% } else { %>
            <p class="no-data"><i class="fas fa-exclamation-circle"></i> No team members found for your projects.</p>
        <% } %>
    </div>
</body>
</html>