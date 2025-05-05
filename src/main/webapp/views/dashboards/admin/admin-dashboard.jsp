<%@page import="in.efficio.dao.PendingRegistrationDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.DashboardStats, java.util.List, in.efficio.model.Project, in.efficio.dao.PendingRegistrationDAO"%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/style.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/views/assets/images/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/notifications.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <%
        if (session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }
        String userName = (String) session.getAttribute("userName");
        DashboardStats stats = (DashboardStats) request.getAttribute("stats");
        if (stats == null) stats = new DashboardStats();
        
        // Get contentType, default to welcome
        String contentType = request.getParameter("contentType") != null ? request.getParameter("contentType") : "welcome";
        String lastContentType = (String) session.getAttribute("lastContentType");
        
        
        // Update session
        session.setAttribute("lastContentType", contentType);
        request.setAttribute("contentType", contentType);

        String from = request.getParameter("from");
        PendingRegistrationDAO pendingDAO = new PendingRegistrationDAO();
        boolean hasUnseen = pendingDAO.hasUnseenRegistrations();
    %>

    <div class="container">
        <!-- Debug output -->
        <div style="background: #ffe6e6; padding: 10px; margin: 10px; border: 1px solid red;">
            <p>Debug: contentType=<%=contentType%>, lastContentType=<%=lastContentType%></p>
        </div>

        <aside class="sidebar">
            <div class="sidebar-profile">
                <img src="${pageContext.request.contextPath}/views/assets/images/admin-avtar.png" alt="Admin Avatar">
                <h3><%=userName%></h3>
            </div>
            <nav class="menu">
                <ul>
                    <li><a href="javascript:void(0)" id="toggleSidebar"><i class="fas fa-bars"></i> <span>Menu</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/DashboardServlet?contentType=welcome" <%= "welcome".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/Employees?contentType=view-employees" <%= "view-employees".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-users"></i> <span>View Employees</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/TeamLeaders?contentType=view-teamleaders" <%= "view-teamleaders".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-user-tie"></i> <span>View Team Leaders</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/Projects?contentType=create-projects" <%= "create-projects".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-folder-plus"></i> <span>Create Projects</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/Projects?contentType=view-projects" <%= "view-projects".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-eye"></i> <span>View Projects</span></a></li>
                    <li><a href="${pageContext.request.contextPath}/Projects?contentType=assign-team-leaders" <%= "assign-team-leaders".equals(contentType) || "project-team-leaders".equals(contentType) ? "class='active'" : "" %>><i class="fas fa-user-tie"></i> <span>Assign Team Leaders</span></a></li>
                    <li class="logout"><a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fas fa-sign-out-alt"></i> <span>Logout</span></a></li>
                </ul>
            </nav>
        </aside>

        <main class="main-content">
            <header class="topbar">
                <h2 id="pageTitle">
                    <i class="<%= "welcome".equals(contentType) ? "fas fa-tachometer-alt" 
                        : "view-employees".equals(contentType) ? "fas fa-users" 
                        : "employee-profile".equals(contentType) ? "fas fa-users" 
                        : "view-teamleaders".equals(contentType) ? "fas fa-user-tie" 
                        : "teamleader-profile".equals(contentType) ? "fas fa-user-tie" 
                        : "create-projects".equals(contentType) ? "fas fa-folder-plus" 
                        : "view-projects".equals(contentType) ? "fas fa-eye" 
                        : "assign-team-leaders".equals(contentType) ? "fas fa-user-tie" 
                        : "project-team-leaders".equals(contentType) ? "fas fa-project-diagram" 
                        : "adminsList".equals(contentType) ? "fas fa-user-shield" 
                        : "projectsList".equals(contentType) ? "fas fa-project-diagram" 
                        : "pendingList".equals(contentType) ? "fas fa-tasks" 
                        : "completedList".equals(contentType) ? "fas fa-check-circle" 
                        : "productivityList".equals(contentType) ? "fas fa-chart-line" 
                        : "notifications".equals(contentType) ? "fas fa-bell" 
                        : "fas fa-tachometer-alt" %>"></i>
                    <%= "welcome".equals(contentType) ? "Dashboard" 
                        : "view-employees".equals(contentType) ? "View Employees" 
                        : "employee-profile".equals(contentType) ? "Employee Profile" 
                        : "view-teamleaders".equals(contentType) ? "View Team Leaders" 
                        : "teamleader-profile".equals(contentType) ? "Team Leader Profile" 
                        : "create-projects".equals(contentType) ? "Create Projects" 
                        : "view-projects".equals(contentType) ? "View Projects" 
                        : "assign-team-leaders".equals(contentType) ? "Assign Team Leaders" 
                        : "project-team-leaders".equals(contentType) ? "Project Team Leaders" 
                        : "adminsList".equals(contentType) ? "Admins List" 
                        : "projectsList".equals(contentType) ? "All Projects" 
                        : "pendingList".equals(contentType) ? "Pending Projects" 
                        : "completedList".equals(contentType) ? "Completed Projects" 
                        : "productivityList".equals(contentType) ? "Productivity" 
                        : "notifications".equals(contentType) ? "Pending Requests" 
                        : "Dashboard" %>
                </h2>
                <div class="icons">
                    <div class="notification">
                        <a href="${pageContext.request.contextPath}/DashboardServlet?contentType=notifications" id="notificationBell">
                            <i class="fas fa-bell"></i>
                            <span class="update-dot" id="notificationDot" style="display: <%= hasUnseen ? "block" : "none" %>;"></span>
                        </a>
                    </div>
                    <div class="profile">
                        <img src="${pageContext.request.contextPath}/views/assets/images/admin.png" alt="Profile" id="profileIcon">
                        <div class="dropdown-content" id="profileDropdown">
                            <a href="#"><i class="fas fa-user"></i> Profile</a>
                            <a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
                        </div>
                    </div>
                </div>
            </header>

            <section class="dashboard-content">
                <div class="notification-panel" id="notificationPanel" style="display: <%= "notifications".equals(contentType) ? "block" : "none" %>;">
                    <jsp:include page="notifications.jsp" />
                </div>
                <div class="dashboard-inner" id="dashboardInner">
                    <% if ("welcome".equals(contentType)) { %>
                        <h1><i class="fas fa-handshake"></i> Welcome, <%=userName%>!</h1>
                        <div class="stats-container">
                            <div class="stat-box">
                                <h2><%=stats.getAdminCount()%></h2>
                                <p><i class="fas fa-user-shield"></i> Admins</p>
                                <form action="${pageContext.request.contextPath}/DashboardServlet" method="get">
                                    <input type="hidden" name="contentType" value="adminsList">
                                    <button type="submit" class="show-btn">Show Information</button>
                                </form>
                            </div>
                            <div class="stat-box">
                                <h2><%=stats.getProjectCount()%></h2>
                                <p><i class="fas fa-project-diagram"></i> Projects</p>
                                <form action="${pageContext.request.contextPath}/DashboardServlet" method="get">
                                    <input type="hidden" name="contentType" value="projectsList">
                                    <button type="submit" class="show-btn">Show Information</button>
                                </form>
                            </div>
                            <div class="stat-box">
                                <h2><%=stats.getPendingTaskCount()%></h2>
                                <p><i class="fas fa-tasks"></i> Pending Projects</p>
                                <form action="${pageContext.request.contextPath}/DashboardServlet" method="get">
                                    <input type="hidden" name="contentType" value="pendingList">
                                    <button type="submit" class="show-btn">Show Information</button>
                                </form>
                            </div>
                            <div class="stat-box">
                                <h2><%=stats.getCompletedTaskCount()%></h2>
                                <p><i class="fas fa-check-circle"></i> Completed Projects</p>
                                <form action="${pageContext.request.contextPath}/DashboardServlet" method="get">
                                    <input type="hidden" name="contentType" value="completedList">
                                    <button type="submit" class="show-btn">Show Information</button>
                                </form>
                            </div>
                            <div class="stat-box">
                                <h2><%=String.format("%.2f", stats.getProductivity())%>%</h2>
                                <p><i class="fas fa-chart-line"></i> Productivity</p>
                                <form action="${pageContext.request.contextPath}/DashboardServlet" method="get">
                                    <input type="hidden" name="contentType" value="productivityList">
                                    <button type="submit" class="show-btn">Show Information</button>
                                </form>
                            </div>
                        </div>
                    <% } else if ("adminsList".equals(contentType) || "projectsList".equals(contentType) || 
                                  "pendingList".equals(contentType) || "completedList".equals(contentType) || 
                                  "productivityList".equals(contentType)) { %>
                        <div class="info-section">
                            <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/DashboardServlet?contentType=welcome'"><i class="fas fa-arrow-left"></i> Back</button>
                            <% 
                                List<Project> projects = (List<Project>) request.getAttribute("projects");
                                if ("adminsList".equals(contentType)) {
                                    out.println("<h3>Admins List</h3><p>List of admins will be implemented later.</p>");
                                } else if ("projectsList".equals(contentType) && projects != null) {
                                    out.println("<h3>All Projects</h3><ul class='project-list'>");
                                    for (Project p : projects) {
                                        out.println("<li>" + p.getProjectName() + " (" + p.getStatus() + ") " +
                                            "<a href='" + request.getContextPath() + "/Projects?contentType=view-projects&action=view&projectId=" + p.getProjectId() + "&from=projectsList' class='view-btn'>View Report</a></li>");
                                    }
                                    out.println("</ul>");
                                } else if ("pendingList".equals(contentType) && projects != null) {
                                    out.println("<h3>Pending Projects</h3><ul class='project-list'>");
                                    for (Project p : projects) {
                                        out.println("<li>" + p.getProjectName() + " " +
                                            "<a href='" + request.getContextPath() + "/Projects?contentType=view-projects&action=view&projectId=" + p.getProjectId() + "&from=pendingList' class='view-btn'>View Report</a></li>");
                                    }
                                    out.println("</ul>");
                                } else if ("completedList".equals(contentType) && projects != null) {
                                    out.println("<h3>Completed Projects</h3><ul class='project-list'>");
                                    for (Project p : projects) {
                                        out.println("<li>" + p.getProjectName() + " " +
                                            "<a href='" + request.getContextPath() + "/Projects?contentType=view-projects&action=view&projectId=" + p.getProjectId() + "&from=completedList' class='view-btn'>View Report</a></li>");
                                    }
                                    out.println("</ul>");
                                } else if ("productivityList".equals(contentType)) {
                                    out.println("<h3>Productivity</h3>");
                                    out.println("<p>Completed: " + stats.getCompletedTaskCount() + "</p>");
                                    out.println("<p>Pending: " + stats.getPendingTaskCount() + "</p>");
                                    out.println("<p>Productivity: " + String.format("%.2f", stats.getProductivity()) + "%</p>");
                                }
                            %>
                        </div>
                    <% } else if ("view-employees".equals(contentType)) { %>
                        <div class="employee-list">
                            <jsp:include page="employee-list.jsp" />
                        </div>
                    <% } else if ("employee-profile".equals(contentType)) { %>
                        <button class="back-btn" onclick="window.location.href='<%="project-view".equals(from) ? request.getContextPath() + "/Projects?contentType=view-projects&action=view&projectId=" + request.getParameter("projectId") : request.getContextPath() + "/Employees?contentType=view-employees"%>'"><i class="fas fa-arrow-left"></i> Back</button>
                        <div class="employee-profile">
                            <jsp:include page="employee-profile.jsp" />
                        </div>
                    <% } else if ("view-teamleaders".equals(contentType)) { %>
                        <div class="teamleader-list">
                            <jsp:include page="teamleader_list.jsp" />
                        </div>
                    <% } else if ("teamleader-profile".equals(contentType)) { %>
                        <button class="back-btn" onclick="window.location.href='<%="project-team-leaders".equals(from) ? request.getContextPath() + "/Projects?contentType=project-team-leaders&projectId=" + request.getParameter("projectId") : "project-view".equals(from) ? request.getContextPath() + "/Projects?contentType=view-projects&action=view&projectId=" + request.getParameter("projectId") : request.getContextPath() + "/TeamLeaders?contentType=view-teamleaders"%>'"><i class="fas fa-arrow-left"></i> Back</button>
                        <div class="teamleader-profile">
                            <jsp:include page="teamleader_profile.jsp" />
                        </div>
                    <% } else if ("create-projects".equals(contentType)) { %>
                        <div class="create-project">
                            <jsp:include page="create-project.jsp" />
                        </div>
                    <% } else if ("view-projects".equals(contentType)) { %>
                        <div class="project-list">
                            <jsp:include page="view-projects.jsp" />
                        </div>
                    <% } else if ("assign-team-leaders".equals(contentType)) { %>
                        <div class="assign-team-leaders">
                            <jsp:include page="assign-team-leaders.jsp" />
                        </div>
                    <% } else if ("project-team-leaders".equals(contentType)) { %>
                        <div class="project-team-leaders">
                            <jsp:include page="project-team-leaders.jsp" />
                        </div>
                    <% } else if ("notifications".equals(contentType)) { %>
                        <div class="notifications">
                            <jsp:include page="notifications.jsp" />
                        </div>
                    <% } else { %>
                        <p>Coming soon! This feature will be implemented later.</p>
                    <% } %>
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

   
   