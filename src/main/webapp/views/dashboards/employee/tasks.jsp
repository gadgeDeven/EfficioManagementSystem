<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="in.efficio.model.Task, java.util.List" %>
<%
    List<Task> tasks = (List<Task>) request.getAttribute("tasks");
    if (tasks == null) {
        tasks = new ArrayList();
    }
%>
<div class="tasks-container">
    <h2>My Tasks</h2>
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Task Title</th>
                    <th>Project</th>
                    <th>Status</th>
                    <th>Progress</th>
                    <th>Deadline</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="task" items="${tasks}">
                    <tr>
                        <td>${task.taskTitle}</td>
                        <td>${task.projectName}</td>
                        <td>${task.status}</td>
                        <td>${task.progressPercentage}%</td>
                        <td>${task.deadlineDate}</td>
                        <td>
                            <a href="EmployeeTaskServlet?action=view&taskId=${task.taskId}" class="btn btn-small">View</a>
                            <a href="EmployeeTaskServlet?action=updateProgress&taskId=${task.taskId}" class="btn btn-small">Update</a>
                        </td>
                    </tr>
                </c:forEach>
                <% if (tasks.isEmpty()) { %>
                    <tr>
                        <td colspan="6">No tasks assigned.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>