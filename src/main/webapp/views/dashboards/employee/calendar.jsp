<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, in.efficio.model.Task, in.efficio.model.Project, java.text.SimpleDateFormat, java.util.Calendar" %>
<div class="calendar-container">
    <% 
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null && !errorMessage.isEmpty()) {
    %>
        <div class="alert-error">
            <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
        </div>
    <% } %>
    <%
        Calendar today = Calendar.getInstance();
        int todayDay = today.get(Calendar.DAY_OF_MONTH);
        int todayMonth = today.get(Calendar.MONTH);
        int todayYear = today.get(Calendar.YEAR);
        SimpleDateFormat todaySdf = new SimpleDateFormat("MMM d, yyyy");

        Calendar cal = Calendar.getInstance();
        String monthParam = request.getParameter("month");
        String yearParam = request.getParameter("year");
        int currentMonth = monthParam != null ? Integer.parseInt(monthParam) : todayMonth;
        int currentYear = yearParam != null ? Integer.parseInt(yearParam) : todayYear;
        cal.set(currentYear, currentMonth, 1);
        int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
        int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Calendar prevCal = (Calendar) cal.clone();
        prevCal.add(Calendar.MONTH, -1);
        Calendar nextCal = (Calendar) cal.clone();
        nextCal.add(Calendar.MONTH, 1);
    %>
    <div class="calendar-nav">
        <a href="${pageContext.request.contextPath}/EmployeeDashboardServlet?contentType=calendar&month=<%= prevCal.get(Calendar.MONTH) %>&year=<%= prevCal.get(Calendar.YEAR) %>"><i class="fas fa-chevron-left"></i> Previous</a>
        <div class="nav-center">
            <span class="today-date">Today: <%= todaySdf.format(today.getTime()) %></span>
            <select id="monthSelect" onchange="navigateCalendar()">
                <% 
                    String[] months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                    for (int i = 0; i < 12; i++) {
                %>
                    <option value="<%= i %>" <%= i == currentMonth ? "selected" : "" %>><%= months[i] %></option>
                <% } %>
            </select>
            <select id="yearSelect" onchange="navigateCalendar()">
                <% 
                    int currentYearNow = Calendar.getInstance().get(Calendar.YEAR);
                    for (int year = currentYearNow - 5; year <= currentYearNow + 5; year++) {
                %>
                    <option value="<%= year %>" <%= year == currentYear ? "selected" : "" %>><%= year %></option>
                <% } %>
            </select>
        </div>
        <a href="${pageContext.request.contextPath}/EmployeeDashboardServlet?contentType=calendar&month=<%= nextCal.get(Calendar.MONTH) %>&year=<%= nextCal.get(Calendar.YEAR) %>">Next <i class="fas fa-chevron-right"></i></a>
    </div>
    <table class="calendar-table">
        <thead>
            <tr>
                <th>Sun</th><th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Task> tasks = (List<Task>) request.getAttribute("tasks");
                List<Project> projects = (List<Project>) request.getAttribute("projects");
                Map<String, List<Task>> taskMap = new HashMap<>();
                Map<String, List<Project>> projectStartMap = new HashMap<>();

                if (tasks != null) {
                    for (Task task : tasks) {
                        if (task.getDeadlineDate() != null) {
                            String dateStr = sdf.format(task.getDeadlineDate());
                            taskMap.computeIfAbsent(dateStr, k -> new ArrayList<>()).add(task);
                        }
                    }
                }

                if (projects != null) {
                    for (Project project : projects) {
                        if (project.getStartDate() != null) {
                            String startDateStr = sdf.format(project.getStartDate());
                            projectStartMap.computeIfAbsent(startDateStr, k -> new ArrayList<>()).add(project);
                        }
                    }
                }

                int day = 1;
                boolean firstWeek = true;
                while (day <= daysInMonth) {
            %>
            <tr>
                <%
                    for (int i = 1; i <= 7; i++) {
                        if (firstWeek && i < firstDayOfWeek || day > daysInMonth) {
                %>
                    <td class="empty"></td>
                <%
                        } else {
                            String dateStr = String.format("%d-%02d-%02d", currentYear, currentMonth + 1, day);
                            boolean isToday = (day == todayDay && currentMonth == todayMonth && currentYear == todayYear);
                            String cellClass = isToday ? "today" : "";
                %>
                    <td class="<%= cellClass %>">
                        <div class="day-number"><%= day %></div>
                        <%
                            List<Task> dayTasks = taskMap.get(dateStr);
                            if (dayTasks != null) {
                                for (Task task : dayTasks) {
                        %>
                            <div class="event task-event">
                                <i class="fas fa-tasks"></i>
                                <a href="${pageContext.request.contextPath}/EmployeeTaskServlet?action=view&taskId=<%= task.getTaskId() %>&contentType=tasks&filter=all">
                                    <%= task.getTaskTitle() != null ? task.getTaskTitle() : "Task" %>
                                </a>
                                <span class="tooltip">Task: <%= task.getTaskTitle() != null ? task.getTaskTitle() : "Task" %> (Deadline)</span>
                            </div>
                        <%
                                }
                            }
                            List<Project> startProjects = projectStartMap.get(dateStr);
                            if (startProjects != null) {
                                for (Project project : startProjects) {
                        %>
                            <div class="event project-start">
                                <i class="fas fa-play"></i>
                                <a href="${pageContext.request.contextPath}/EmployeeProjectServlet?contentType=projects&action=view&projectId=<%= project.getProjectId() %>">
                                    <%= project.getProjectName() != null ? project.getProjectName() : "Project" %>
                                </a>
                                <span class="tooltip">Project: <%= project.getProjectName() != null ? project.getProjectName() : "Project" %> (Start)</span>
                            </div>
                        <%
                                }
                            }
                        %>
                    </td>
                <%
                            day++;
                        }
                    }
                    firstWeek = false;
                %>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>
<script>
    const contextPath = '<%= request.getContextPath() %>';
    function navigateCalendar() {
        const month = document.getElementById('monthSelect').value;
        const year = document.getElementById('yearSelect').value;
        window.location.href = `${contextPath}/EmployeeDashboardServlet?contentType=calendar&month=${month}&year=${year}`;
    }
</script>