<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.DashboardStats" %>
<%
    String displayName = (String) session.getAttribute("displayName");
    if (displayName == null) {
        displayName = "Employee";
    }
    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    if (stats == null) {
        stats = new DashboardStats();
    }
%>
<style>
.stat-box button {
    background: #670bf5;
    color: #fff;
    border: none;
    padding: 8px 15px;
    border-radius: 20px;
    cursor: pointer;
}
.stat-box button:hover {
    background: #5a0ad6;
    transform: translateY(-2px);
}
</style>

<h1><i class="fas fa-handshake"></i> Welcome, <%= displayName %>!</h1>
<div class="stats-container">
    <div class="stat-box">
        <h2><%= stats.getTaskCount() %></h2>
        <p><i class="fas fa-tasks"></i> My Tasks</p>
        <form action="${pageContext.request.contextPath}/EmployeeTaskServlet" method="get">
            <input type="hidden" name="contentType" value="tasks">
            <input type="hidden" name="filter" value="all">
            <button type="submit" class="show-btn">Show Information</button>
        </form>
    </div>
    <div class="stat-box">
        <h2><%= stats.getPendingTaskCount() %></h2>
        <p><i class="fas fa-hourglass-half"></i> Pending Tasks</p>
        <form action="${pageContext.request.contextPath}/EmployeeTaskServlet" method="get">
            <input type="hidden" name="contentType" value="tasks">
            <input type="hidden" name="filter" value="pending">
            <button type="submit" class="show-btn">Show Information</button>
        </form>
    </div>
    <div class="stat-box">
        <h2><%= stats.getCompletedTaskCount() %></h2>
        <p><i class="fas fa-check-circle"></i> Completed Tasks</p>
        <form action="${pageContext.request.contextPath}/EmployeeTaskServlet" method="get">
            <input type="hidden" name="contentType" value="tasks">
            <input type="hidden" name="filter" value="completed">
            <button type="submit" class="show-btn">Show Information</button>
        </form>
    </div>
    <div class="stat-box">
        <h2><%= stats.getProjectCount() %></h2>
        <p><i class="fas fa-project-diagram"></i> My Projects</p>
        <form action="${pageContext.request.contextPath}/EmployeeProjectServlet" method="get">
            <input type="hidden" name="contentType" value="projects">
            <button type="submit" class="show-btn">Show Information</button>
        </form>
    </div>
    <div class="stat-box">
        <h2><%= String.format("%.1f", stats.getProductivity()) %>%</h2>
        <p><i class="fas fa-chart-line"></i> Productivity</p>
        <form action="${pageContext.request.contextPath}/EmployeeDashboardServlet" method="get">
            <input type="hidden" name="contentType" value="welcome">
            <button type="submit" class="show-btn">Show Information</button>
        </form>
    </div>
</div>