<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Task"%>
<div class="tasks-container">
    <h1><i class="fas fa-tasks"></i> 
        <% 
            String filter = (String) request.getAttribute("filter");
            String title = "all".equals(filter) ? "My Tasks" : 
                          "pending".equals(filter) ? "Pending Tasks" : 
                          "Completed Tasks";
        %>
        <%= title %>
    </h1>
    <%
        List<Task> tasks = (List<Task>) request.getAttribute("tasks");
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");
    %>
    <% if (successMessage != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> <%= successMessage %>
        </div>
    <% } %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
        </div>
    <% } %>
    <div class="table-modern">
        <table>
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
                <% 
                    if (tasks != null && !tasks.isEmpty()) {
                        for (Task task : tasks) {
                %>
                    <tr class="<%= task.getStatus().equals("Completed") ? "completed-row" : "pending-row" %>">
                        <td><%= task.getTaskTitle() != null ? task.getTaskTitle() : "N/A" %></td>
                        <td><%= task.getProjectName() != null ? task.getProjectName() : "N/A" %></td>
                        <td><%= task.getStatus() != null ? task.getStatus() : "N/A" %></td>
                        <td>
                            <div class="progress-container">
                                <div class="progress" style="width: <%= task.getProgressPercentage() %>%;"></div>
                            </div>
                            <%= task.getProgressPercentage() %>%
                        </td>
                        <td><%= task.getDeadlineDate() != null ? task.getDeadlineDate() : "N/A" %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/EmployeeTaskServlet?action=view&taskId=<%= task.getTaskId() %>&contentType=tasks&filter=<%= filter %>" class="action-btn">
                                <i class="fas fa-eye"></i> View
                            </a>
                            <a href="${pageContext.request.contextPath}/EmployeeTaskServlet?action=updateProgress&taskId=<%= task.getTaskId() %>&contentType=tasks&filter=<%= filter %>" class="action-btn">
                                <i class="fas fa-edit"></i> Update
                            </a>
                        </td>
                    </tr>
                <% 
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="6" class="no-data">
                            <i class="fas fa-info-circle"></i> No tasks found.
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
<style>
.tasks-container {
    padding: 20px;
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}
.tasks-container h1 {
    color: #6b48ff;
    font-size: 28px;
    text-align: center;
    margin-bottom: 20px;
}
.table-modern {
    width: 100%;
    border-collapse: collapse;
    background: #ffffff;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}
.table-modern th,
.table-modern td {
    padding: 14px;
    text-align: center;
    font-size: 14px;
    border-bottom: 1px solid #e0e0e0;
}
.table-modern th {
    background: #6b21a8;
    color: #fff;
    font-weight: 700;
}
.table-modern td {
    background: #ffffff;
}
.table-modern tr:nth-child(even) td {
    background: #f9fafb;
}
.table-modern tr:hover td {
    background: rgba(107, 33, 168, 0.05);
}
.progress-container {
    width: 100px;
    height: 10px;
    background: #e0e0e0;
    border-radius: 5px;
    display: inline-block;
}
.progress {
    height: 100%;
    background: #28a745;
    border-radius: 5px;
}
.action-btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 8px 16px;
    background: #00a1a7;
    color: #ffffff;
    text-decoration: none;
    border-radius: 6px;
    font-size: 14px;
    margin: 0 5px;
}
.action-btn:hover {
    background: #00888f;
    transform: translateY(-2px);
}
.alert {
    padding: 12px;
    margin-bottom: 15px;
    border-radius: 6px;
    font-size: 14px;
    display: flex;
    align-items: center;
}
.alert-success {
    background: rgba(40, 167, 69, 0.1);
    color: #28a745;
    border: 1px solid #28a745;
}
.alert-error {
    background: rgba(220, 53, 69, 0.1);
    color: #dc3545;
    border: 1px solid #dc3545;
}
.no-data {
    font-size: 14px;
    color: #dc3545;
    padding: 20px;
    text-align: center;
}
.completed-row {
    background: #e6ffed; /* Light green for completed */
}
.pending-row {
    background: #fff7e6; /* Light yellow for pending */
}
</style>