package in.efficio.controllers;

import in.efficio.dao.EmployeeDAO;
import in.efficio.dao.ProjectDAO;
import in.efficio.model.Employee;
import in.efficio.model.Project;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet("/EmployeeTeamServlet")
public class EmployeeTeamServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EmployeeTeamServlet.class.getName());
    private EmployeeDAO employeeDAO;
    private ProjectDAO projectDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
        projectDAO = new ProjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        int employeeId = (Integer) session.getAttribute("employeeId");
        String contentType = request.getParameter("contentType");
        String filterProjectIdStr = request.getParameter("filterProjectId");
        if (contentType == null) {
            contentType = "team-members";
        }

        LOGGER.info("Fetching team members for employee ID: " + employeeId);

        // Fetch projects assigned to the employee
        List<Integer> projectIds = new ArrayList<>();
        List<Project> projects = projectDAO.getProjectsByEmployee(employeeId);
        for (Project project : projects) {
            projectIds.add(project.getProjectId());
        }
        LOGGER.info("Found " + projectIds.size() + " projects for employee ID: " + employeeId + " - " + projectIds);

        // Fetch team members assigned to these projects
        List<Employee> teamMembers = new ArrayList<>();
        if (!projectIds.isEmpty()) {
            StringBuilder teamQuery = new StringBuilder(
                "SELECT DISTINCT e.employee_id, e.name, e.email, d.department_name, tl.name AS teamleader_name, " +
                "mn.mobile_number, p.project_id, p.project_name " +
                "FROM employee e " +
                "JOIN works_on wo ON e.employee_id = wo.employee_id " +
                "LEFT JOIN department d ON e.dept_id = d.department_id " +
                "LEFT JOIN team_leader tl ON wo.teamleader_id = tl.teamleader_id " +
                "LEFT JOIN mobile_numbers mn ON mn.role_id = e.employee_id AND mn.role_type = 'Employee' " +
                "JOIN project p ON wo.project_id = p.project_id " +
                "WHERE wo.project_id IN (" + projectIds.stream().map(String::valueOf).collect(Collectors.joining(",")) + ") " +
                "AND e.employee_id != ?"
            );

            // Apply project filter if specified
            int parameterIndex = 1;
            if (filterProjectIdStr != null && !filterProjectIdStr.isEmpty()) {
                try {
                    int filterProjectId = Integer.parseInt(filterProjectIdStr);
                    if (projectIds.contains(filterProjectId)) {
                        teamQuery.append(" AND wo.project_id = ?");
                    } else {
                        LOGGER.warning("Invalid filterProjectId: " + filterProjectId + " for employee ID: " + employeeId);
                    }
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid filterProjectId format: " + filterProjectIdStr);
                }
            }

            try (Connection con = in.efficio.dbconnection.DbConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(teamQuery.toString())) {
                ps.setInt(parameterIndex++, employeeId);
                if (filterProjectIdStr != null && !filterProjectIdStr.isEmpty()) {
                    try {
                        int filterProjectId = Integer.parseInt(filterProjectIdStr);
                        if (projectIds.contains(filterProjectId)) {
                            ps.setInt(parameterIndex, filterProjectId);
                        }
                    } catch (NumberFormatException e) {
                        // Already logged above
                    }
                }
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Employee emp = new Employee();
                    emp.setEmployee_id(rs.getInt("employee_id"));
                    emp.setName(rs.getString("name"));
                    emp.setEmail(rs.getString("email"));
                    emp.setDept_name(rs.getString("department_name"));
                    emp.setTeamLeader_name(rs.getString("teamleader_name"));
                    emp.setMobileNumber(rs.getString("mobile_number"));
                    emp.setAssign_project_id(rs.getInt("project_id"));
                    emp.setAssign_project_name(rs.getString("project_name"));
                    teamMembers.add(emp);
                }
                LOGGER.info("Fetched " + teamMembers.size() + " team members for employee ID: " + employeeId);
            } catch (Exception e) {
                LOGGER.severe("Error fetching team members for employee " + employeeId + ": " + e.getMessage());
            }
        } else {
            LOGGER.warning("No projects found for employee ID: " + employeeId);
        }

        request.setAttribute("teamMembers", teamMembers);
        request.setAttribute("projects", projects);
        request.setAttribute("selectedProjectId", filterProjectIdStr);
        request.setAttribute("contentType", contentType);
        request.setAttribute("includePath", "team-members.jsp");
        request.getRequestDispatcher("/views/dashboards/employee/EmployeeDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}