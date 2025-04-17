<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Employee"%>
<h1>Team Members</h1>
<button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'"><i class="fas fa-arrow-left"></i> Back</button>
<div class="team-members-container">
    <% List<Employee> teamMembers = (List<Employee>) request.getAttribute("teamMembers"); %>
    <% Integer teamMemberCount = (Integer) request.getAttribute("teamMemberCount"); %>
    <% if (teamMembers != null && !teamMembers.isEmpty()) { %>
        <h2>Team Size: <%= teamMemberCount != null ? teamMemberCount : 0 %></h2>
        <table class="table-modern">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Department</th>
                    <th>Assigned Projects</th>
                </tr>
            </thead>
            <tbody>
                <% for (Employee employee : teamMembers) { %>
                    <tr>
                        <td><%= employee.getName() != null ? employee.getName() : "N/A" %></td>
                        <td><%= employee.getEmail() != null ? employee.getEmail() : "N/A" %></td>
                        <td><%= employee.getDept_name() != null ? employee.getDept_name() : "N/A" %></td>
                        <td><%= employee.getAssign_project_name() != null ? employee.getAssign_project_name() : "None" %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p>No team members assigned.</p>
    <% } %>
</div>