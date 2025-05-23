<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.Task, in.efficio.model.Project, in.efficio.model.Employee, java.util.List, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Task Details | Efficio</title>
    <!-- Project-specific styling ke liye view-projects.css -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/view-projects.css">
    <!-- Font Awesome icons ke liye -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <!-- Task details ka main container -->
    <div class="proj-list-container">
        <%-- Error messages ke liye alert --%>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
            <p class="proj-no-data">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </p>
        <%
            }
        %>

        <%-- Task details display --%>
        <%
            Task taskDetails = (Task) request.getAttribute("taskDetails");
            if (taskDetails != null) {
                Project project = (Project) request.getAttribute("project");
                SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                String filter = (String) request.getAttribute("filter");
                if (filter == null) filter = "all";
        %>
            <div class="proj-details">
                <div class="proj-header">
                    <a href="?contentType=tasks&filter=<%= filter %>" class="proj-back-btn">
                        <i class="fas fa-arrow-left"></i> Back
                    </a>
                    <h1><i class="fas fa-tasks"></i> <%= taskDetails.getTaskTitle() != null ? taskDetails.getTaskTitle() : "N/A" %></h1>
                </div>
                <div class="proj-details-grid">
                    <p class="proj-description">
                        <strong><i class="fas fa-info-circle"></i> Description:</strong> 
                        <%= taskDetails.getDescription() != null ? taskDetails.getDescription() : "N/A" %>
                    </p>
                    <div class="proj-date-status-grid">
                        <p>
                            <strong><i class="fas fa-project-diagram"></i> Project:</strong> 
                            <%= project != null && project.getProjectName() != null ? project.getProjectName() : "N/A" %>
                        </p>
                        <p>
                            <strong><i class="fas fa-user-tie"></i> Assigned By:</strong> 
                            <%= taskDetails.getTeamLeaderName() != null ? taskDetails.getTeamLeaderName() : "Unknown Team Leader" %>
                        </p>
                        <p>
                            <strong><i class="fas fa-calendar-check"></i> Deadline:</strong> 
                            <%= taskDetails.getDeadlineDate() != null ? sdf.format(taskDetails.getDeadlineDate()) : "N/A" %>
                        </p>
                        <p>
                            <strong><i class="fas fa-tasks"></i> Status:</strong> 
                            <%= taskDetails.getStatus() != null ? taskDetails.getStatus() : "N/A" %>
                        </p>
                    </div>
                    <div class="proj-progress-bar">
                        <label><i class="fas fa-chart-line"></i> Progress:</label>
                        <div class="progress-container">
                            <div class="progress" style="width: <%= taskDetails.getProgressPercentage() %>%;"></div>
                        </div>
                        <span><%= taskDetails.getProgressPercentage() %>%</span>
                    </div>
                    <p class="proj-description">
                        <strong><i class="fas fa-comment"></i> Progress Message:</strong> 
                        <%= taskDetails.getProgressMessage() != null ? taskDetails.getProgressMessage() : "No message" %>
                    </p>
                </div>
                <div class="proj-actions">
                    <a href="?action=updateProgress&taskId=<%= taskDetails.getTaskId() %>&contentType=tasks&filter=<%= filter %>" class="proj-btn">
                        <i class="fas fa-edit"></i> Update Progress
                    </a>
                </div>
                <h3><i class="fas fa-users"></i> Assigned Employees</h3>
                <div class="proj-employee-list">
                    <%
                        List<Employee> employeesOnTask = (List<Employee>) request.getAttribute("employeesOnTask");
                        if (employeesOnTask == null || employeesOnTask.isEmpty()) {
                    %>
                        <p class="proj-no-data">
                            <i class="fas fa-info-circle"></i> No employees assigned to this task.
                        </p>
                    <%
                        } else {
                            for (Employee employee : employeesOnTask) {
                    %>
                        <div class="proj-employee-item">
                            <p><strong>Employee ID:</strong> <%= employee.getEmployee_id() %></p>
                            <p><strong>Name:</strong> <%= employee.getName() != null ? employee.getName() : "Unknown Employee" %></p>
                        </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>
        <%
            } else {
        %>
            <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> Task not found.</p>
        <%
            }
        %>
    </div>
</body>
</html>