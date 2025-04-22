
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task"%>
<h1>Completed Tasks</h1>
<button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/TeamLeaderDashboard?contentType=welcome'"><i class="fas fa-arrow-left"></i> Back</button>
<div class="table-container">
    <table class="table-modern">
        <thead>
            <tr>
                <th>Task Title</th>
                <th>Description</th>
                <th>Status</th>
                <th>Deadline</th>
                <th>Assigned To</th>
            </tr>
        </thead>
        <tbody>
            <% 
                List<Task> completedTasks = (List<Task>) request.getAttribute("completedTasks");
                if (completedTasks != null && !completedTasks.isEmpty()) {
                    for (Task task : completedTasks) {
            %>
                <tr>
                    <td><%=task.getTaskTitle()%></td>
                    <td><%=task.getDescription()%></td>
                    <td><%=task.getStatus()%></td>
                    <td><%=task.getDeadlineDate()%></td>
                    <td><%=task.getAssignedToEmployeeId()%></td>
                </tr>
            <% 
                    }
                } else {
            %>
                <tr><td colspan="5">No completed tasks found.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>
