<%@ page import="java.util.List" %>
<%@ page import="in.efficio.model.Employee" %>
<%@ page import="in.efficio.model.Project" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Employees</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/lists.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="employee-list-container">
    <h3 class="total-employees">Total Employees: 
        <% 
            Integer empCount = (Integer) request.getAttribute("employeeCount");
            out.print(empCount != null ? empCount : "No data found");
        %>
    </h3>
    <% List<Employee> employees = (List<Employee>) request.getAttribute("employees"); %>
    <% if ("view-employees".equals(request.getParameter("contentType")) && employees != null && !employees.isEmpty()) { %>
        <div class="table-wrapper">
            <table>
                <tr id="heading">
                    <th><i class="fas fa-id-badge"></i> ID</th>
                    <th><i class="fas fa-user"></i> Name</th>
                    <th><i class="fas fa-envelope"></i> Email</th>
                    <th><i class="fas fa-building"></i> Department</th>
                    <th><i class="fas fa-user-tie"></i> Team Leader IDs</th>
                    <th><i class="fas fa-project-diagram"></i> Projects</th>
                    <th><i class="fas fa-eye"></i> Profile</th>
                </tr>
                <% for (Employee emp : employees) { %>
                    <tr>
                        <td><%= emp.getEmployee_id() %></td>
                        <td><%= emp.getName() != null ? emp.getName() : "N/A" %></td>
                        <td><%= emp.getEmail() != null ? emp.getEmail() : "N/A" %></td>
                        <td><%= emp.getDept_name() != null ? emp.getDept_name() : "N/A" %></td>
                        <td>
                            <% 
                                Set<Integer> teamLeaderIds = emp.getTeamLeaderIds();
                                if (teamLeaderIds != null && !teamLeaderIds.isEmpty()) {
                                    int i = 0;
                                    for (Integer tlId : teamLeaderIds) {
                            %>
                                        <a href="${pageContext.request.contextPath}/TeamLeaders?id=<%= tlId %>&contentType=teamleader-profile" class="plain-link"><%= tlId %></a>
                                        <%= i < teamLeaderIds.size() - 1 ? ", " : "" %>
                            <% 
                                        i++;
                                    }
                                } else {
                                    out.print("None");
                                }
                            %>
                        </td>
                        <td>
                            <% 
                                List<Project> projects = emp.getProjects();
                                if (projects != null && !projects.isEmpty()) {
                                    for (int i = 0; i < projects.size(); i++) {
                                        Project project = projects.get(i);
                            %>
                                        <a href="${pageContext.request.contextPath}/Projects?contentType=view-projects&action=view&projectId=<%= project.getProjectId() %>" class="plain-link"><%= project.getProjectId() %></a>
                                        <%= i < projects.size() - 1 ? ", " : "" %>
                            <% 
                                    }
                                } else {
                                    out.print("None");
                                }
                            %>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/Employees?id=<%= emp.getEmployee_id() %>&contentType=employee-profile" class="view-btn">
                                Profile
                            </a>
                        </td>
                    </tr>
                <% } %>
            </table>
        </div>
    <% } else { %>
        <p class="no-data"><i class="fas fa-exclamation-circle"></i> No employees found.</p>
    <% } %>
</div>
<script src="${pageContext.request.contextPath}/views/assets/js/admin/employee_list.js"></script>
</body>
</html>