<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.Employee, in.efficio.model.Project, in.efficio.model.Task, java.util.List"%>
<html>
<head>
    <title>Employee Profile</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/assets/css/teamleader/team-member.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="employee-details-container">
     
        <%
            String from = request.getParameter("from");
            String projectId = request.getParameter("projectId");
            String backUrl = request.getContextPath() + "/TeamLeaderTeamServlet?contentType=team-members";
            if ("project-details".equals(from) && projectId != null) {
                backUrl = request.getContextPath() + "/TeamLeaderProjectServlet?contentType=project-details&projectId=" + projectId;
            }
            Integer currentTeamLeaderId = (Integer) request.getAttribute("currentTeamLeaderId");
        %>
        <button class="back-btn" onclick="window.location.href='<%=backUrl%>'">
            <i class="fas fa-arrow-left"></i> Back
        </button>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            Employee employee = (Employee) request.getAttribute("employee");
            if (errorMessage != null) {
        %>
                <div class="alert alert-error"><i class="fas fa-exclamation-triangle"></i> <%= errorMessage %></div>
        <%
            }
            if (employee != null) {
        %>
                <div class="profile-card">
                    <div class="profile-details-content">
                        <p><strong><i class="fas fa-user"></i> Name:</strong> <%= employee.getName() != null ? employee.getName() : "N/A" %></p>
                        <p><strong><i class="fas fa-id-badge"></i> ID:</strong> <%= employee.getEmployee_id() %></p>
                        <p><strong><i class="fas fa-envelope"></i> Email:</strong> <%= employee.getEmail() != null ? employee.getEmail() : "N/A" %></p>
                        <p><strong><i class="fas fa-building"></i> Department:</strong> <%= employee.getDept_name() != null ? employee.getDept_name() : "N/A" %></p>
                        <p><strong><i class="fas fa-tools"></i> Skills:</strong> <%= employee.getSkills() != null ? employee.getSkills() : "N/A" %></p>
                        <p><strong><i class="fas fa-star"></i> Rating:</strong>
                            <span class="rating-stars">
                                <span style="width: <%= employee.getRating() * 20 %>%;"></span>
                            </span> (<%= employee.getRating() %>/5)
                        </p>
                        <p><strong><i class="fas fa-info-circle"></i> Status:</strong> <%= employee.getStatus() != null ? employee.getStatus() : "N/A" %></p>
                        <p><strong><i class="fas fa-calendar-alt"></i> Date of Birth:</strong> <%= employee.getDob() != null ? employee.getDob() : "N/A" %></p>
                    </div>
                    <div class="profile-photo">
                        <i class="fas fa-user-circle"></i>
                    </div>
                </div>
                <!-- Projects Section -->
                <h2><i class="fas fa-project-diagram"></i> Assigned Projects</h2>
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th><i class="fas fa-id-card"></i> Project ID</th>
                            <th><i class="fas fa-folder-open"></i> Project Name</th>
                            <th><i class="fas fa-user-tie"></i> Team Leader</th>
                            <th><i class="fas fa-cog"></i> Action/Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Project> projects = employee.getProjects();
                            if (projects != null && !projects.isEmpty()) {
                                for (Project project : projects) {
                        %>
                                    <tr>
                                        <td><%= project.getProjectId() %></td>
                                        <td><%= project.getProjectName() != null ? project.getProjectName() : "N/A" %></td>
                                        <td><%= project.getTeamLeaderName() != null ? project.getTeamLeaderName() : "N/A" %></td>
                                        <td>
                                            <%
                                                Integer projectTeamLeaderId = project.getTeamLeaderId();
                                                if (currentTeamLeaderId != null && projectTeamLeaderId != null && projectTeamLeaderId.equals(currentTeamLeaderId)) {
                                            %>
                                                    <a href="${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=projects&action=view&projectId=<%= project.getProjectId() %>" class="action-btn"><i class="fas fa-eye"></i> View Project</a>
                                            <%
                                                } else {
                                            %>
                                                    <span><%= project.getDescription() != null ? project.getDescription() : "No description available" %></span>
                                            <%
                                                }
                                            %>
                                        </td>
                                    </tr>
                        <%
                                }
                            } else {
                        %>
                                <tr>
                                    <td colspan="4">No projects assigned</td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <!-- Tasks Section -->
<h2><i class="fas fa-tasks"></i> Assigned Tasks</h2>
<table class="table-modern">
    <thead>
        <tr>
            <th><i class="fas fa-id-card"></i> Task ID</th>
            <th><i class="fas fa-clipboard"></i> Task Title</th>
            <th><i class="fas fa-folder-open"></i> Project Name</th>
            <th><i class="fas fa-info-circle"></i> Status</th>
            <th><i class="fas fa-calendar-alt"></i> Deadline</th>
            <th><i class="fas fa-cog"></i> Action</th>
        </tr>
    </thead>
    <tbody>
        <%
            List<Task> tasks = employee.getTasks();
            if (tasks != null && !tasks.isEmpty()) {
                for (Task task : tasks) {
                    if (task != null) {
        %>
                        <tr>
                            <td><%= task.getTaskId() != 0 ? task.getTaskId() : "N/A" %></td>
                            <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
                            <td><%= task.getProjectName() != null ? task.getProjectName() : "N/A" %></td>
                            <td><%= task.getStatus() != null ? task.getStatus() : "N/A" %></td>
                            <td><%= task.getDeadlineDate() != null ? task.getDeadlineDate() : "N/A" %></td>
                            <td>
                                <a href="<%=request.getContextPath()%>/TeamLeaderTaskServlet?contentType=tasks&action=view&taskId=<%=task.getTaskId()%>" class="action-btn">
                                    <i class="fas fa-eye"></i> View Task
                                </a>
                            </td>
                        </tr>
        <%
                    }
                }
            } else {
        %>
                    <tr>
                        <td colspan="6">No tasks assigned</td>
                    </tr>
        <%
            }
        %>
    </tbody>
</table>
        <%
            } else {
        %>
                <p class="no-data"><i class="fas fa-info-circle"></i> Employee data not available.</p>
        <%
            }
        %>
    </div>
</body>
</html>