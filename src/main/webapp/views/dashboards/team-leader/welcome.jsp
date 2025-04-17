<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.DashboardStats"%>
<%
    String displayName = (String) session.getAttribute("displayName");
    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
%>
<h1><i class="fas fa-handshake"></i> Welcome, <%=displayName%>!</h1>
<div class="stats-container">
    <div class="stat-box">
        <h2><%=stats.getProjectCount()%></h2>
        <p><i class="fas fa-project-diagram"></i> My Projects</p>
        <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="getHISTORICAL">
            <input type="hidden" name="contentType" value="projects">
            <button type="submit" class="show-btn">View</button>
        </form>
    </div>
    <div class="stat-box">
        <h2><%=stats.getPendingProjectCount()%></h2>
        <p><i class="fas fa-hourglass-half"></i> Pending Projects</p>
        <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="get">
            <input type="hidden" name="contentType" value="pending-projects">
            <button type="submit" class="show-btn">View</button>
        </form>
    </div>
    <div class="stat-box">
        <h2><%=stats.getCompletedProjectCount()%></h2>
        <p><i class="fas fa-check-circle"></i> Completed Projects</p>
        <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="get">
            <input type="hidden" name="contentType" value="completed-projects">
            <button type="submit" class="show-btn">View</button>
        </form>
    </div>
    <div class="stat-box">
        <h2><%=stats.getTaskCount()%></h2>
        <p><i class="fas fa-tasks"></i> Tasks</p>
        <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="get">
            <input type="hidden" name="contentType" value="tasks">
            <button type="submit" class="show-btn">View</button>
        </form>
    </div>
    <div class="stat-box">
        <h2><%=stats.getPendingTaskCount()%></h2>
        <p><i class="fas fa-hourglass-half"></i> Pending Tasks</p>
        <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="get">
            <input type="hidden" name="contentType" value="pending-tasks">
            <button type="submit" class="show-btn">View</button>
        </form>
    </div>
    <div class="stat-box">
        <h2><%=stats.getCompletedTaskCount()%></h2>
        <p><i class="fas fa-check-circle"></i> Completed Tasks</p>
        <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="get">
            <input type="hidden" name="contentType" value="completed-tasks">
            <button type="submit" class="show-btn">View</button>
        </form>
    </div>
    <div class="stat-box">
        <h2><%=String.format("%.1f", stats.getProductivity())%>%</h2>
        <p><i class="fas fa-chart-line"></i> Productivity</p>
        <form action="${pageContext.request.contextPath}/TeamLeaderDashboard" method="get">
            <input type="hidden" name="contentType" value="productivity">
            <button type="submit" class="show-btn">View</button>
        </form>
    </div>
</div>