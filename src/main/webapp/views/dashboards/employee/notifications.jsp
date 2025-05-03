<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task, in.efficio.dao.TaskDAO"%>
<div class="notification-list">
    <h3><i class="fas fa-bell"></i> Notifications</h3>
    <%
        Integer employeeId = (Integer) session.getAttribute("employeeId");
        if (employeeId == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }
        TaskDAO taskDAO = new TaskDAO();
        List<Task> unseenTasks = taskDAO.getTasksByEmployeeId(employeeId);
        unseenTasks.removeIf(task -> task.getSeen() != null && task.getSeen());
        int unseenCount = unseenTasks.size();
        request.setAttribute("unseenNotifications", unseenCount);
    %>
    <% if (unseenTasks.isEmpty()) { %>
        <p class="no-notifications"><i class="fas fa-info-circle"></i> No new notifications.</p>
    <% } else { %>
        <ul>
            <% for (Task task : unseenTasks) { %>
                <% if (task == null) continue; %>
                <li class="notification-item">
                    <div class="notification-content">
                        <strong><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></strong>
                        <p>Project: <%= task.getProjectName() != null ? task.getProjectName() : "N/A" %></p>
                    </div>
                    <form action="${pageContext.request.contextPath}/EmployeeTaskServlet" method="post" class="mark-seen-form">
                        <input type="hidden" name="action" value="markTaskAsSeen">
                        <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                        <input type="hidden" name="contentType" value="notifications">
                        <button type="submit" class="btn-mark-seen"><i class="fas fa-eye"></i> Mark as Seen</button>
                    </form>
                </li>
            <% } %>
        </ul>
    <% } %>
</div>