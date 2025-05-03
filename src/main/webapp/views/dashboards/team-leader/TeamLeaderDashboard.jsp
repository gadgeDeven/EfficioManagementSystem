<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.DashboardStats, java.util.List, in.efficio.model.Task"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Team Leader Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/style.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/views/assets/images/favicon.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <%
        if (session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }
        String teamLeaderEmail = (String) session.getAttribute("userName");
        String displayName = (String) session.getAttribute("displayName");
        DashboardStats stats = (DashboardStats) request.getAttribute("stats");
        if (stats == null) stats = new DashboardStats();
        String contentType = (String) request.getAttribute("contentType");
        if (contentType == null) contentType = request.getParameter("contentType") != null ? request.getParameter("contentType") : "welcome";
    %>

    <div class="container">
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-profile">
                <img src="${pageContext.request.contextPath}/views/assets/images/admin-avtar.png" alt="Team Leader Avatar">
                <h3><%=displayName%></h3>
            </div>
            <nav class="menu">
                <ul>
                    <li><a href="#" id="toggleSidebar"><i class="fas fa-bars"></i> <span>Menu</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome" <%= "welcome".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/TeamLeaderProjectServlet?contentType=projects" <%= "projects".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-project-diagram"></i> <span>Projects</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=tasks&taskFilter=all" <%= "tasks".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-tasks"></i> <span>Tasks</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=create-task" <%= "create-task".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-plus-circle"></i> <span>Create Task</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/TeamLeaderTaskServlet?contentType=assign-task" <%= "assign-task".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-user-check"></i> <span>Assign Task</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/TeamLeaderAssignmentServlet?contentType=assign-projects" <%= "assign-projects".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-user-plus"></i> <span>Assign Projects</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/TeamLeaderTeamServlet?contentType=team-members" <%= "team-members".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-users"></i> <span>Team Members</span></a></li>
                    <li class="logout"><a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
                </ul>
            </nav>
        </aside>

        <main class="main-content" id="mainContent">
            <header class="topbar">
                <h2 id="pageTitle">
                    <i class="<%= "welcome".equals(contentType) ? "fas fa-tachometer-alt" 
                        : "projects".equals(contentType) || "pending-projects".equals(contentType) || "completed-projects".equals(contentType) ? "fas fa-project-diagram" 
                        : "tasks".equals(contentType) || "pending-tasks".equals(contentType) || "completed-tasks".equals(contentType) ? "fas fa-tasks" 
                        : "create-task".equals(contentType) ? "fas fa-plus-circle" 
                        : "assign-task".equals(contentType) ? "fas fa-user-check" 
                        : "assign-projects".equals(contentType) ? "fas fa-user-plus" 
                        : "team-members".equals(contentType) ? "fas fa-users" 
                        : "notifications".equals(contentType) ? "fas fa-bell" 
                        : "project-details".equals(contentType) ? "fas fa-project-diagram" 
                        : "employee-details".equals(contentType) ? "fas fa-user" 
                        : "task-details".equals(contentType) ? "fas fa-tasks" 
                        : "edit-task".equals(contentType) ? "fas fa-edit" 
                        : "tasks-by-project".equals(contentType) ? "fas fa-tasks" 
                        : "settings".equals(contentType) ? "fas fa-cog" 
                        : "fas fa-tachometer-alt" %>"></i>
                    <%= "welcome".equals(contentType) ? "Dashboard" 
                        : "projects".equals(contentType) ? "Projects" 
                        : "pending-projects".equals(contentType) ? "Pending Projects" 
                        : "completed-projects".equals(contentType) ? "Completed Projects" 
                        : "tasks".equals(contentType) ? "Tasks" 
                        : "pending-tasks".equals(contentType) ? "Pending Tasks" 
                        : "completed-tasks".equals(contentType) ? "Completed Tasks" 
                        : "create-task".equals(contentType) ? "Create Task" 
                        : "assign-task".equals(contentType) ? "Assign Task" 
                        : "assign-projects".equals(contentType) ? "Assign Projects" 
                        : "team-members".equals(contentType) ? "Team Members" 
                        : "notifications".equals(contentType) ? "Notifications" 
                        : "project-details".equals(contentType) ? "Project Details" 
                        : "employee-details".equals(contentType) ? "Employee Details" 
                        : "task-details".equals(contentType) ? "Task Details" 
                        : "edit-task".equals(contentType) ? "Edit Task" 
                        : "tasks-by-project".equals(contentType) ? "Tasks by Project" 
                        : "settings".equals(contentType) ? "Settings" 
                        : "Dashboard" %>
                </h2>
                <div class="icons">
                    <div class="notification">
                        <a href="javascript:void(0)" id="notificationBell">
                            <i class="fas fa-bell"></i>
                            <% 
                                List<Task> adminTasks = (List<Task>) request.getAttribute("adminTasks");
                                List<Task> taskUpdates = (List<Task>) request.getAttribute("taskUpdates");
                                boolean hasNotifications = (adminTasks != null && !adminTasks.isEmpty()) || (taskUpdates != null && !taskUpdates.isEmpty());
                            %>
                            <span class="update-dot" id="notificationDot" style="display: <%= hasNotifications ? "block" : "none" %>;"></span>
                        </a>
                    </div>
                    <div class="profile">
                        <img src="${pageContext.request.contextPath}/views/assets/images/admin.png" alt="Profile" id="profileIcon">
                        <div class="dropdown-content" id="profileDropdown">
                            <a href="${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=profile"><i class="fas fa-user"></i> View Profile</a>
                            <a href="${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=settings"><i class="fas fa-cog"></i> Settings</a>
                            <a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
                        </div>
                    </div>
                </div>
            </header>

            <section class="dashboard-content">
                <div class="notification-panel" id="notificationPanel">
                    <jsp:include page="notifications.jsp" />
                </div>
                <div class="dashboard-inner" id="dashboardInner">
                    <% 
                        String includePath = (String) request.getAttribute("includePath");
                        if (includePath == null) {
                            includePath = "welcome.jsp";
                        }
                    %>
                    <jsp:include page="<%=includePath%>" />
                </div>
            </section>
        </main>
    </div>

    <script>
        const contextPath = '<%=request.getContextPath()%>';
        const currentContentType = '<%=contentType%>';
    </script>
    <script src="${pageContext.request.contextPath}/views/assets/js/admin/script.js"></script>
</body>
</html>