<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Project, in.efficio.model.TeamLeader, in.efficio.model.Employee"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Projects</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/view-projects.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="proj-list-container">
    <h1>
        <% String contentType = request.getParameter("contentType"); %>
        <%= "pending-projects".equals(contentType) ? "Pending Projects" : "completed-projects".equals(contentType) ? "Completed Projects" : "My Projects" %>
    </h1>
    <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'"><i class="fas fa-arrow-left"></i> Back to Dashboard</button>

    <!-- Messages -->
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% String successMessage = (String) request.getAttribute("successMessage"); %>
    <% if (errorMessage != null) { %>
        <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> <%= errorMessage %></p>
    <% } %>
    <% if (successMessage != null) { %>
        <p class="proj-success-msg"><i class="fas fa-check-circle"></i> <%= successMessage %></p>
    <% } %>

    <!-- Project Details or List -->
    <% Project selectedProject = (Project) request.getAttribute("selectedProject"); %>
    <% List<TeamLeader> teamLeaders = (List<TeamLeader>) request.getAttribute("teamLeaders"); %>
    <% List<Employee> employees = (List<Employee>) request.getAttribute("employees"); %>
    <% Integer progress = (Integer) request.getAttribute("progress"); %>
    <% if (selectedProject != null) { %>
        <div class="proj-details">
            <div class="proj-header">
                <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=<%= contentType %>'"><i class="fas fa-arrow-left"></i> Back to Projects</button>
                <h1><i class="fas fa-project-diagram"></i> <%= selectedProject.getProjectName() %></h1>
            </div>
            <div class="proj-details-grid">
                <p class="proj-description"><strong><i class="fas fa-info-circle"></i> Description:</strong> <%= selectedProject.getDescription() != null ? selectedProject.getDescription() : "N/A" %></p>
                <div class="proj-date-status-grid">
                    <p><strong><i class="fas fa-calendar-alt"></i> Start Date:</strong> <%= selectedProject.getStartDate() != null ? selectedProject.getStartDate() : "N/A" %></p>
                    <p><strong><i class="fas fa-calendar-check"></i> End Date:</strong> <%= selectedProject.getEndDate() != null ? selectedProject.getEndDate() : "N/A" %></p>
                    <p><strong><i class="fas fa-tasks"></i> Status:</strong> <%= selectedProject.getStatus() != null ? selectedProject.getStatus() : "N/A" %></p>
                    <p><strong><i class="fas fa-exclamation-triangle"></i> Priority:</strong> <%= selectedProject.getPriority() != null ? selectedProject.getPriority() : "N/A" %></p>
                </div>
                <div class="proj-progress-bar">
                    <label><i class="fas fa-chart-line"></i> Progress:</label>
                    <div class="progress-container">
                        <div class="progress" style="width: <%= progress != null ? progress : 0 %>%;"></div>
                    </div>
                    <span><%= progress != null ? progress : 0 %>%</span>
                </div>
            </div>
            <h3><i class="fas fa-user-tie"></i> Team Leaders</h3>
            <div class="proj-team-list">
                <% if (teamLeaders != null && !teamLeaders.isEmpty()) { %>
                    <% for (TeamLeader tl : teamLeaders) { %>
                        <div class="proj-team-item">
                            <a href="${pageContext.request.contextPath}/TeamLeaders?contentType=teamleader-profile&id=<%= tl.getTeamleader_id() %>&from=project-view&projectId=<%= selectedProject.getProjectId() %>">
                                <%= tl.getName() != null ? tl.getName() : "N/A" %>
                            </a>
                        </div>
                    <% } %>
                <% } else { %>
                    <p class="proj-no-data">No team leaders assigned.</p>
                <% } %>
            </div>
            <h3><i class="fas fa-users"></i> Employees</h3>
            <div class="proj-employee-list">
                <% if (employees != null && !employees.isEmpty()) { %>
                    <% for (Employee emp : employees) { %>
                        <div class="proj-employee-item">
                            <a href="${pageContext.request.contextPath}/Employees?contentType=employee-profile&id=<%= emp.getEmployee_id() %>&from=project-view&projectId=<%= selectedProject.getProjectId() %>">
                                <%= emp.getName() != null ? emp.getName() : "N/A" %>
                            </a>
                        </div>
                    <% } %>
                <% } else { %>
                    <p class="proj-no-data">No employees assigned.</p>
                <% } %>
            </div>
            <div class="proj-actions">
                <form action="${pageContext.request.contextPath}/TeamLeaderProjectServlet" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="contentType" value="<%= contentType %>">
                    <input type="hidden" name="projectId" value="<%= selectedProject.getProjectId() %>">
                    <button type="submit" class="proj-btn proj-success"><i class="fas fa-edit"></i> Update</button>
                </form>
                <form action="${pageContext.request.contextPath}/TeamLeaderProjectServlet" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="complete">
                    <input type="hidden" name="contentType" value="<%= contentType %>">
                    <input type="hidden" name="projectId" value="<%= selectedProject.getProjectId() %>">
                    <button type="submit" class="proj-btn proj-success"><i class="fas fa-check"></i> Complete</button>
                </form>
                <a href="${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=<%= contentType %>&action=download&projectId=<%= selectedProject.getProjectId() %>" class="proj-btn"><i class="fas fa-download"></i> Download</a>
            </div>
        </div>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Status</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
                <% if (projects != null && !projects.isEmpty()) { %>
                    <% for (Project project : projects) { %>
                        <tr>
                            <td><%= project.getProjectId() %></td>
                            <td><%= project.getProjectName() %></td>
                            <td><%= project.getStatus() != null ? project.getStatus() : "N/A" %></td>
                            <td><%= project.getStartDate() != null ? project.getStartDate() : "N/A" %></td>
                            <td><%= project.getEndDate() != null ? project.getEndDate() : "N/A" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=<%= contentType %>&projectId=<%= project.getProjectId() %>" class="proj-btn">View Details</a>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr><td colspan="6"><p class="no-data">No projects found.</p></td></tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>
</body>
</html>