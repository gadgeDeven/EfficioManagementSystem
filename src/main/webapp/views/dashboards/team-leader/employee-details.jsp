<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.Employee"%>

<div class="container">
    <h1>Employee Details</h1>
    <% String projectId = request.getParameter("projectId"); %>
    <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=assign-projects&projectId=<%= projectId != null ? projectId : "" %>'">Back to Assign Projects</button>

    <!-- Messages -->
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>

    <!-- Employee Details -->
    <% Employee employee = (Employee) request.getAttribute("employee"); %>
    <% Boolean isAssigned = (Boolean) request.getAttribute("isAssigned"); %>
    <% if (employee != null) { %>
        <table class="table-modern">
            <tr>
                <th>ID</th>
                <td><%= employee.getEmployee_id() %></td>
            </tr>
            <tr>
                <th>Name</th>
                <td><%= employee.getName() %></td>
            </tr>
            <tr>
                <th>Email</th>
                <td><%= employee.getEmail() %></td>
            </tr>
            <tr>
                <th>Department</th>
                <td><%= employee.getDept_name() != null ? employee.getDept_name() : "N/A" %></td>
            </tr>
            <tr>
                <th>Skills</th>
                <td><%= employee.getSkills() != null ? employee.getSkills() : "N/A" %></td>
            </tr>
            <tr>
                <th>Rating</th>
                <td><%= employee.getRating() != 0 ? employee.getRating() : "N/A" %></td>
            </tr>
            <tr>
                <th>Status</th>
                <td><%= employee.getStatus() != null ? employee.getStatus() : "N/A" %></td>
            </tr>
            <tr>
                <th>Project Assignment</th>
                <td><%= isAssigned != null && isAssigned ? "Assigned" : "Not Assigned" %></td>
            </tr>
        </table>
    <% } else { %>
        <p style="text-align: center;">No employee details available.</p>
    <% } %>
</div>