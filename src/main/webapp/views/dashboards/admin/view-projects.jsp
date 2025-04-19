<%@ page import="java.util.List" %>
<%@ page import="in.efficio.model.Project" %>
<%@ page import="in.efficio.model.TeamLeader" %>
<%@ page import="in.efficio.model.Employee" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Projects</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/view-projects.css">
</head>
<body>
    <div class="proj-list-container">
        <% if (!"view".equals(request.getParameter("action")) && !"edit".equals(request.getParameter("action"))) { %>
            <%-- Display success or error message --%>
            <% String message = (String) session.getAttribute("message"); %>
            <% String error = (String) session.getAttribute("error"); %>
            <% if (message != null) { %>
                <p class="proj-success-msg"><i class="fas fa-check-circle"></i> <%= message %></p>
                <% session.removeAttribute("message"); %>
            <% } %>
            <% if (error != null) { %>
                <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> <%= error %></p>
                <% session.removeAttribute("error"); %>
            <% } %>
            <% List<Project> projects = (List<Project>) request.getAttribute("projects"); %>
            <% if (projects != null && !projects.isEmpty()) { %>
                <table>
                    <tr>
                        <th><i class="fas fa-id-badge"></i> ID</th>
                        <th><i class="fas fa-project-diagram"></i> Name</th>
                        <th><i class="fas fa-info-circle"></i> Description</th>
                        <th><i class="fas fa-calendar-alt"></i> Start Date</th>
                        <th><i class="fas fa-calendar-check"></i> End Date</th>
                        <th><i class="fas fa-tasks"></i> Status</th>
                        <th><i class="fas fa-exclamation-triangle"></i> Priority</th>
                        <th><i class="fas fa-eye"></i> Actions</th>
                    </tr>
                    <% for (Project project : projects) { %>
                        <tr>
                            <td><%= project.getProjectId() %></td>
                            <td><%= project.getProjectName() %></td>
                            <td><%= project.getDescription() %></td>
                            <td><%= project.getStartDate() %></td>
                            <td><%= project.getEndDate() %></td>
                            <td><%= project.getStatus() %></td>
                            <td><%= project.getPriority() %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/Projects?contentType=view-projects&action=view&projectId=<%= project.getProjectId() %>" class="proj-btn"><i class="fas fa-eye"></i> View</a>
                            </td>
                        </tr>
                    <% } %>
                </table>
            <% } else { %>
                <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> No projects found.</p>
            <% } %>
        <% } else if ("view".equals(request.getParameter("action"))) { 
            Project project = (Project) request.getAttribute("projectDetails");
            List<TeamLeader> teamLeaders = (List<TeamLeader>) request.getAttribute("teamLeaders");
            List<Employee> employees = (List<Employee>) request.getAttribute("employees");
            Integer progress = (Integer) request.getAttribute("progress");
            String from = request.getParameter("from");
            String id = request.getParameter("id");
        %>
            <div class="proj-details">
                <div class="proj-header">
                    <button class="proj-back-btn" onclick="window.location.href='<%= 
                        "projectsList".equals(from) ? request.getContextPath() + "/DashboardServlet?contentType=projectsList" 
                        : "pendingList".equals(from) ? request.getContextPath() + "/DashboardServlet?contentType=pendingList" 
                        : "completedList".equals(from) ? request.getContextPath() + "/DashboardServlet?contentType=completedList" 
                        : "employee-profile".equals(from) ? request.getContextPath() + "/Employees?contentType=employee-profile&id=" + (id != null ? id : "") 
                        : "view-employees".equals(from) ? request.getContextPath() + "/Employees?contentType=view-employees" 
                        : "teamleader-profile".equals(from) ? request.getContextPath() + "/TeamLeaders?contentType=teamleader-profile&id=" + (id != null ? id : "") 
                        : "view-teamleaders".equals(from) ? request.getContextPath() + "/TeamLeaders?contentType=view-teamleaders" 
                        : request.getContextPath() + "/Projects?contentType=view-projects" %>'"><i class="fas fa-arrow-left"></i> Back</button>
                    <h1><i class="fas fa-project-diagram"></i> <%= project.getProjectName() %></h1>
                </div>
                <div class="proj-details-grid">
                    <p class="proj-description"><strong><i class="fas fa-info-circle"></i> Description:</strong> <%= project.getDescription() %></p>
                    <div class="proj-date-status-grid">
                        <p><strong><i class="fas fa-calendar-alt"></i> Start Date:</strong> <%= project.getStartDate() %></p>
                        <p><strong><i class="fas fa-calendar-check"></i> End Date:</strong> <%= project.getEndDate() %></p>
                        <p><strong><i class="fas fa-tasks"></i> Status:</strong> <%= project.getStatus() %></p>
                        <p><strong><i class="fas fa-exclamation-triangle"></i> Priority:</strong> <%= project.getPriority() %></p>
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
                    <% for (TeamLeader tl : teamLeaders) { %>
                        <div class="proj-team-item"><a href="${pageContext.request.contextPath}/TeamLeaders?contentType=teamleader-profile&id=<%= tl.getTeamleader_id() %>&from=project-view&projectId=<%= project.getProjectId() %>"><%= tl.getName() %></a></div>
                    <% } %>
                </div>
                <h3><i class="fas fa-users"></i> Employees</h3>
                <div class="proj-employee-list">
                    <% for (Employee emp : employees) { %>
                        <div class="proj-employee-item"><a href="${pageContext.request.contextPath}/Employees?contentType=employee-profile&id=<%= emp.getEmployee_id() %>&from=project-view&projectId=<%= project.getProjectId() %>"><%= emp.getName() %></a></div>
                    <% } %>
                </div>
                <div class="proj-actions">
                    <form action="${pageContext.request.contextPath}/DeleteProject" method="post" style="display:inline;">
                        <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                        <button type="submit" class="proj-btn proj-danger" onclick="return confirm('Are you sure?');"><i class="fas fa-trash"></i> Delete</button>
                    </form>
                    <a href="${pageContext.request.contextPath}/Projects?contentType=view-projects&action=edit&projectId=<%= project.getProjectId() %>&from=<%= from != null ? from : "" %>&id=<%= id != null ? id : "" %>" class="proj-btn"><i class="fas fa-edit"></i> Edit</a>
                    <form action="${pageContext.request.contextPath}/Projects" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="complete">
                        <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                        <button type="submit" class="proj-btn proj-success"><i class="fas fa-check"></i> Complete</button>
                    </form>
                    <a href="${pageContext.request.contextPath}/Projects?contentType=view-projects&action=download&projectId=<%= project.getProjectId() %>" class="proj-btn"><i class="fas fa-download"></i> Download</a>
                </div>
            </div>
        <% } else if ("edit".equals(request.getParameter("action"))) { 
            Project project = (Project) request.getAttribute("projectDetails");
            String from = request.getParameter("from");
            String id = request.getParameter("id");
        %>
            <div class="proj-edit">
                <div class="proj-header">
                    <button class="proj-back-btn" onclick="window.location.href='${pageContext.request.contextPath}/Projects?contentType=view-projects&action=view&projectId=<%= project.getProjectId() %>&from=<%= from != null ? from : "" %>&id=<%= id != null ? id : "" %>'"><i class="fas fa-arrow-left"></i> Back</button>
                    <h1><i class="fas fa-edit"></i> Edit <%= project.getProjectName() %></h1>
                </div>
                <form action="${pageContext.request.contextPath}/Projects" method="post">
                    <input type="hidden" name="action" value="updateProject">
                    <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                    <div class="proj-form-group">
                        <label><i class="fas fa-project-diagram"></i> Project Name:</label>
                        <input type="text" name="projectName" value="<%= project.getProjectName() %>" required>
                    </div>
                    <div class="proj-form-group">
                        <label><i class="fas fa-info-circle"></i> Description:</label>
                        <textarea name="description" required><%= project.getDescription() %></textarea>
                    </div>
                    <div class="proj-form-actions">
                        <button type="submit" class="proj-btn"><i class="fas fa-save"></i> Save Changes</button>
                    </div>
                </form>
            </div>
        <% } %>
    </div>
</body>
</html>