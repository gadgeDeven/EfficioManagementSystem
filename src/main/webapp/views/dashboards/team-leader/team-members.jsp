<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Employee, in.efficio.model.Task"%>
<html>
<head>
    <title>Team Members</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/assets/css/teamleader/team-member.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="team-members-container">
        
        <%
            List<Employee> teamMembers = (List<Employee>) request.getAttribute("teamMembers");
            Integer teamMemberCount = (Integer) request.getAttribute("teamMemberCount");
            if (teamMembers != null && !teamMembers.isEmpty()) {
        %>
                <div class="team-size-badge">
                    <i class="fas fa-users"></i> Team Size: <%= teamMemberCount != null ? teamMemberCount : 0 %>
                </div>
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th><i class="fas fa-user"></i> Name</th>
                            <th><i class="fas fa-envelope"></i> Email</th>
                            <th><i class="fas fa-building"></i> Department</th>
                            <th><i class="fas fa-folder-open"></i> Assigned Projects</th>
                            <th><i class="fas fa-clipboard"></i> Task Names</th>
                            <th><i class="fas fa-cog"></i> Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Employee employee : teamMembers) {
                        %>
                            <tr>
                                <td><%= employee.getName() != null ? employee.getName() : "N/A" %></td>
                                <td><%= employee.getEmail() != null ? employee.getEmail() : "N/A" %></td>
                                <td><%= employee.getDept_name() != null ? employee.getDept_name() : "N/A" %></td>
                                <td><%= employee.getAssign_project_name() != null ? employee.getAssign_project_name() : "None" %></td>
                                <td>
                                    <%
                                        List<Task> tasks = employee.getTasks();
                                        if (tasks != null && !tasks.isEmpty()) {
                                            for (int i = 0; i < tasks.size(); i++) {
                                                Task task = tasks.get(i);
                                                out.print(task.getTaskTitle() != null ? task.getTaskTitle() : "N/A");
                                                if (i < tasks.size() - 1) {
                                                    out.print(", ");
                                                }
                                            }
                                        } else {
                                            out.print("None");
                                        }
                                    %>
                                </td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/TeamLeaderTeamServlet?contentType=employee-details&employeeId=<%=employee.getEmployee_id()%>&from=team-members" class="action-btn">
                                        <i class="fas fa-eye"></i> View Profile
                                    </a>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
        <%
            } else {
        %>
                <p class="no-data"><i class="fas fa-info-circle"></i> No team members assigned.</p>
        <%
            }
        %>
    </div>
</body>
</html>