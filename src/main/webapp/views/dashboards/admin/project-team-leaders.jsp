<%@ page import="java.util.List" %>
<%@ page import="in.efficio.model.Project" %>
<%@ page import="in.efficio.model.TeamLeader" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Project Team Leaders</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/assign-team-leaders.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="ptl-container">
        <% 
            String error = (String) session.getAttribute("error");
            String message = (String) session.getAttribute("message");
            if (error != null) { 
        %>
            <div class="ptl-message-box ptl-error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
        <% 
                session.removeAttribute("error");
            } 
            if (message != null) { 
        %>
            <div class="ptl-message-box ptl-success"><i class="fas fa-check-circle"></i> <%= message %></div>
        <% 
                session.removeAttribute("message");
            } 
        %>
        <div class="ptl-header">
            <form action="${pageContext.request.contextPath}/Projects" method="get">
                <input type="hidden" name="contentType" value="assign-team-leaders">
                <button type="submit" class="ptl-btn ptl-btn-back"><i class="fas fa-arrow-left"></i> Back to Projects</button>
            </form>
            <h2><i class="fas fa-project-diagram"></i> Project Team Leaders</h2>
        </div>
        <% 
            Project project = (Project) request.getAttribute("project");
            List<TeamLeader> assignedTeamLeaders = (List<TeamLeader>) request.getAttribute("assignedTeamLeaders");
            List<TeamLeader> availableTeamLeaders = (List<TeamLeader>) request.getAttribute("availableTeamLeaders");
        %>
        <% if (project != null) { %>
            <div class="ptl-content">
                <div class="ptl-project-details">
                    <h3><i class="fas fa-info-circle"></i> Project Details</h3>
                    <div class="ptl-details-grid">
                        <div class="ptl-detail-item">
                            <span class="ptl-detail-label"><i class="fas fa-project-diagram"></i> Name</span>
                            <span class="ptl-detail-value"><%= project.getProjectName() %></span>
                        </div>
                        <div class="ptl-detail-item">
                            <span class="ptl-detail-label"><i class="fas fa-align-left"></i> Description</span>
                            <span class="ptl-detail-value"><%= project.getDescription() %></span>
                        </div>
                        <div class="ptl-detail-item">
                            <span class="ptl-detail-label"><i class="fas fa-calendar-alt"></i> Start Date</span>
                            <span class="ptl-detail-value"><%= project.getStartDate() %></span>
                        </div>
                        <div class="ptl-detail-item">
                            <span class="ptl-detail-label"><i class="fas fa-calendar-check"></i> End Date</span>
                            <span class="ptl-detail-value"><%= project.getEndDate() %></span>
                        </div>
                        <div class="ptl-detail-item">
                            <span class="ptl-detail-label"><i class="fas fa-flag"></i> Status</span>
                            <span class="ptl-detail-value"><%= project.getStatus() %></span>
                        </div>
                        <div class="ptl-detail-item">
                            <span class="ptl-detail-label"><i class="fas fa-exclamation-circle"></i> Priority</span>
                            <span class="ptl-detail-value"><%= project.getPriority() %></span>
                        </div>
                    </div>
                </div>
                <div class="ptl-team-leaders">
                    <h3><i class="fas fa-users"></i> Assigned Team Leaders</h3>
                    <ul>
                        <% if (assignedTeamLeaders != null && !assignedTeamLeaders.isEmpty()) { %>
                            <% for (TeamLeader tl : assignedTeamLeaders) { %>
                                <li>
                                    <span><%= tl.getName() %></span>
                                    <div class="ptl-actions">
                                        <form action="${pageContext.request.contextPath}/TeamLeaders" method="get" style="display:inline;">
                                            <input type="hidden" name="contentType" value="teamleader-profile">
                                            <input type="hidden" name="id" value="<%= tl.getTeamleader_id() %>">
                                            <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                                            <input type="hidden" name="from" value="project-team-leaders">
                                            <button type="submit" class="ptl-btn ptl-btn-profile"><i class="fas fa-user"></i> View Profile</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/Projects" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="removeTeamLeader">
                                            <input type="hidden" name="contentType" value="project-team-leaders">
                                            <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                                            <input type="hidden" name="teamLeaderId" value="<%= tl.getTeamleader_id() %>">
                                            <button type="submit" class="ptl-btn ptl-btn-remove" onclick="return confirm('Are you sure you want to remove this team leader?')"><i class="fas fa-times"></i> Remove</button>
                                        </form>
                                    </div>
                                </li>
                            <% } %>
                        <% } else { %>
                            <li>No team leaders assigned.</li>
                        <% } %>
                    </ul>
                    <h3><i class="fas fa-user-plus"></i> Assign Team Leaders</h3>
                    <form action="${pageContext.request.contextPath}/Projects" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="bulkAssignTeamLeaders">
                        <input type="hidden" name="contentType" value="project-team-leaders">
                        <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                        <% if (availableTeamLeaders != null && !availableTeamLeaders.isEmpty()) { %>
                            <ul class="ptl-available-list">
                                <% for (TeamLeader tl : availableTeamLeaders) { %>
                                    <li>
                                        <div class="ptl-checkbox-group">
                                            <input type="checkbox" class="ptl-team-leader-checkbox" id="tl-<%= tl.getTeamleader_id() %>" name="teamLeaderIds" value="<%= tl.getTeamleader_id() %>">
                                            <label onclick="toggleCheckbox('tl-<%= tl.getTeamleader_id() %>')"><%= tl.getName() %></label>
                                        </div>
                                        <div class="ptl-actions">
                                            <form action="${pageContext.request.contextPath}/TeamLeaders" method="get" style="display:inline;">
                                                <input type="hidden" name="contentType" value="teamleader-profile">
                                                <input type="hidden" name="id" value="<%= tl.getTeamleader_id() %>">
                                                <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                                                <input type="hidden" name="from" value="project-team-leaders">
                                                <button type="submit" class="ptl-btn ptl-btn-profile"><i class="fas fa-user"></i> View Profile</button>
                                            </form>
                                        </div>
                                    </li>
                                <% } %>
                            </ul>
                            <button type="submit" class="ptl-btn ptl-btn-assign ptl-mt-2" onclick="return confirm('Assign selected team leaders?')"><i class="fas fa-plus"></i> Assign Selected</button>
                        <% } else { %>
                            <p>No team leaders available.</p>
                        <% } %>
                    </form>
                </div>
            </div>
        <% } else { %>
            <p><i class="fas fa-exclamation-circle"></i> No project selected.</p>
        <% } %>
    </div>
    <script>
        function toggleCheckbox(id) {
            const checkbox = document.getElementById(id);
            checkbox.checked = !checkbox.checked;
        }

        function validateForm() {
            const checkboxes = document.querySelectorAll('.ptl-team-leader-checkbox:checked');
            if (checkboxes.length === 0) {
                alert('Please select at least one team leader to assign.');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>