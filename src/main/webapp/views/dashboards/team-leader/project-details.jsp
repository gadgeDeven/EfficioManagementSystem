<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project, in.efficio.model.Employee"%>
<h1>Project Details</h1>
<button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=assign-projects'"><i class="fas fa-arrow-left"></i> Back</button>
<div class="project-details-container">
    <% Project project = (Project) request.getAttribute("selectedProject"); %>
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% String successMessage = (String) request.getAttribute("successMessage"); %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>
    <% if (successMessage != null) { %>
        <div class="alert alert-success"><%= successMessage %></div>
    <% } %>
    <% if (project != null) { %>
        <h2><%= project.getProjectName() %></h2>
        <table class="table-modern project-info">
            <tr>
                <th>Description</th>
                <td><%= project.getDescription() != null ? project.getDescription() : "N/A" %></td>
            </tr>
            <tr>
                <th>Start Date</th>
                <td><%= project.getStartDate() != null ? project.getStartDate() : "N/A" %></td>
            </tr>
            <tr>
                <th>End Date</th>
                <td><%= project.getEndDate() != null ? project.getEndDate() : "N/A" %></td>
            </tr>
            <tr>
                <th>Status</th>
                <td><%= project.getStatus() != null ? project.getStatus() : "N/A" %></td>
            </tr>
            <tr>
                <th>Priority</th>
                <td><%= project.getPriority() != null ? project.getPriority() : "N/A" %></td>
            </tr>
        </table>

        <h3>Manage Employees</h3>
        <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="post">
            <input type="hidden" name="action" value="manageEmployees">
            <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
            <table class="table-modern">
                <thead>
                    <tr>
                        <th>Select</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Department</th>
                        <th>Assigned</th>
                    </tr>
                </thead>
                <tbody>
                    <% List<Employee> allEmployees = (List<Employee>) request.getAttribute("allEmployees"); %>
                    <% List<Employee> assignedEmployees = (List<Employee>) request.getAttribute("assignedEmployees"); %>
                    <% if (allEmployees != null) { %>
                        <% for (Employee emp : allEmployees) { %>
                            <tr>
                                <td>
                                    <input type="checkbox" name="employeeIds" value="<%= emp.getEmployee_id() %>"
                                        <%= assignedEmployees != null && assignedEmployees.stream().anyMatch(e -> e.getEmployee_id() == emp.getEmployee_id()) ? "checked" : "" %>>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=employee-details&employeeId=<%= emp.getEmployee_id() %>&projectId=<%= project.getProjectId() %>">
                                        <%= emp.getName() != null ? emp.getName() : "N/A" %>
                                    </a>
                                </td>
                                <td><%= emp.getEmail() != null ? emp.getEmail() : "N/A" %></td>
                                <td><%= emp.getDept_name() != null ? emp.getDept_name() : "N/A" %></td>
                                <td>
                                    <%= assignedEmployees != null && assignedEmployees.stream().anyMatch(e -> e.getEmployee_id() == emp.getEmployee_id()) ? "Yes" : "No" %>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr><td colspan="5">No employees available.</td></tr>
                    <% } %>
                </tbody>
            </table>
            <button type="submit" class="btn-success">Update Assignments</button>
        </form>
    <% } else { %>
        <p>No project selected.</p>
    <% } %>
</div>