<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.DashboardStats"%>
<h1>Productivity</h1>
<div class="productivity-container">
    <% DashboardStats stats = (DashboardStats) request.getAttribute("stats"); %>
    <p>Completed Tasks: <%=stats.getCompletedTaskCount()%></p>
    <p>Pending Tasks: <%=stats.getPendingTaskCount()%></p>
    <p>Productivity: <%=String.format("%.1f", stats.getProductivity())%>%</p>
</div>