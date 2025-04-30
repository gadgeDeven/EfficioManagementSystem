<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Dashboard | Efficio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/employee/calendar.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/views/assets/images/favicon.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <%
        String userName = (String) session.getAttribute("userName");
        String displayName = (String) session.getAttribute("displayName");
        if (userName == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }
        String contentType = request.getParameter("contentType") != null ? request.getParameter("contentType") : "welcome";
        String includePath = (String) request.getAttribute("includePath") != null ? (String) request.getAttribute("includePath") : "welcome.jsp";
        Integer unseenNotifications = (Integer) request.getAttribute("unseenNotifications");
        boolean hasNotifications = unseenNotifications != null && unseenNotifications > 0;
    %>

    <div class="container">
        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-profile">
                <img src="${pageContext.request.contextPath}/views/assets/images/admin-avtar.png" alt="Employee Avatar">
                <h3><%= displayName != null ? displayName : "Employee" %></h3>
            </div>
            <nav class="menu">
                <ul>
                    <li><a href="#" id="toggleSidebar"><i class="fas fa-bars"></i> <span>Menu</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/EmployeeDashboardServlet?contentType=welcome" <%= "welcome".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/EmployeeTaskServlet?contentType=tasks&filter=all" <%= "tasks".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-tasks"></i> <span>My Tasks</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/EmployeeProjectServlet?contentType=projects" <%= "projects".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-project-diagram"></i> <span>Projects</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/EmployeeDashboardServlet?contentType=calendar" <%= "calendar".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-calendar"></i> <span>Calendar</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/EmployeeDashboardServlet?contentType=team-members" <%= "team-members".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-users"></i> <span>Team Members</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/EmployeeDashboardServlet?contentType=feedback" <%= "feedback".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-comment"></i> <span>Feedback</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/EmployeeDashboardServlet?contentType=notifications" <%= "notifications".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-bell"></i> <span>Notifications</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/EmployeeDashboardServlet?contentType=profile" <%= "profile".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-user"></i> <span>Profile Settings</span></a></li>
                    <li class="logout"><a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main-content" id="mainContent">
            <!-- Topbar -->
            <header class="topbar">
                <h2 id="pageTitle">
                    <i class="<%= "welcome".equals(contentType) ? "fas fa-tachometer-alt" 
                        : "tasks".equals(contentType) ? "fas fa-tasks" 
                        : "projects".equals(contentType) ? "fas fa-project-diagram" 
                        : "calendar".equals(contentType) ? "fas fa-calendar" 
                        : "team-members".equals(contentType) ? "fas fa-users" 
                        : "feedback".equals(contentType) ? "fas fa-comment" 
                        : "notifications".equals(contentType) ? "fas fa-bell" 
                        : "profile".equals(contentType) ? "fas fa-user" 
                        : "fas fa-tachometer-alt" %>"></i>
                    <%= "welcome".equals(contentType) ? "Dashboard" 
                        : "tasks".equals(contentType) ? "My Tasks" 
                        : "projects".equals(contentType) ? "Projects" 
                        : "calendar".equals(contentType) ? "Calendar" 
                        : "team-members".equals(contentType) ? "Team Members" 
                        : "feedback".equals(contentType) ? "Feedback" 
                        : "notifications".equals(contentType) ? "Notifications" 
                        : "profile".equals(contentType) ? "Profile Settings" 
                        : "Dashboard" %>
                </h2>
                <div class="icons">
                    <div class="notification">
                        <a href="javascript:void(0)" id="notificationBell">
                            <i class="fas fa-bell"></i>
                            <span class="update-dot" id="notificationDot" style="display: <%= hasNotifications ? "block" : "none" %>;"></span>
                        </a>
                    </div>
                    <div class="profile">
                        <img src="${pageContext.request.contextPath}/views/assets/images/admin.png" alt="Profile" id="profileIcon">
                        <div class="dropdown-content" id="profileDropdown">
                            <a href="${pageContext.request.contextPath}/EmployeeDashboardServlet?contentType=profile"><i class="fas fa-user"></i> View Profile</a>
                            <a href="${pageContext.request.contextPath}/EmployeeDashboardServlet?contentType=settings"><i class="fas fa-cog"></i> Settings</a>
                            <a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Dashboard Content -->
            <section class="dashboard-content">
                <div class="notification-panel" id="notificationPanel">
                    <jsp:include page="notifications.jsp" />
                </div>
                <div class="dashboard-inner" id="dashboardInner">
                    <jsp:include page="<%= includePath %>" />
                </div>
            </section>
        </main>
    </div>

    <script>
        // Set global variables for script.js
        window.contextPath = '<%= request.getContextPath() %>';
        window.currentContentType = '<%= contentType %>';
    </script>
    <script src="${pageContext.request.contextPath}/views/assets/js/admin/script.js"></script>
</body>
</html>