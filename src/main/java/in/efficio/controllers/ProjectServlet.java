package in.efficio.controllers;

import in.efficio.dao.ProjectDAO;
import in.efficio.dao.TeamLeaderDAO;
import in.efficio.dao.EmployeeDAO;
import in.efficio.model.Project;
import in.efficio.model.TeamLeader;
import in.efficio.model.Employee;
import in.efficio.model.DashboardStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/Projects")
public class ProjectServlet extends HttpServlet {
    private ProjectDAO projectDAO;
    private TeamLeaderDAO teamLeaderDAO;
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        projectDAO = new ProjectDAO();
        teamLeaderDAO = new TeamLeaderDAO();
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        String contentType = request.getParameter("contentType");
        String action = request.getParameter("action");
        String filter = request.getParameter("filter");
        String from = request.getParameter("from");
        request.setAttribute("contentType", contentType);
        request.setAttribute("from", from);

        if ("view-projects".equals(contentType)) {
            List<Project> projects;
            if ("pending".equals(filter)) {
                projects = projectDAO.getProjectsByStatus("Ongoing");
            } else if ("completed".equals(filter)) {
                projects = projectDAO.getProjectsByStatus("Completed");
            } else {
                projects = projectDAO.getAllProjects();
            }
            request.setAttribute("projects", projects);
            if ("view".equals(action)) {
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                Project project = projectDAO.getProjectById(projectId);
                List<TeamLeader> teamLeaders = projectDAO.getAssignedTeamLeaders(projectId);
                List<Employee> employees = employeeDAO.getEmployeesByProject(projectId);
                int progress = projectDAO.getProjectProgress(projectId);
                request.setAttribute("projectDetails", project);
                request.setAttribute("teamLeaders", teamLeaders);
                request.setAttribute("employees", employees);
                request.setAttribute("progress", progress);
            } else if ("edit".equals(action)) {
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                Project project = projectDAO.getProjectById(projectId);
                List<TeamLeader> availableTLs = teamLeaderDAO.getAllTeamLeaders();
                request.setAttribute("projectDetails", project);
                request.setAttribute("availableTeamLeaders", availableTLs);
            } else if ("download".equals(action)) {
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                Project project = projectDAO.getProjectById(projectId);
                List<TeamLeader> teamLeaders = projectDAO.getAssignedTeamLeaders(projectId);
                List<Employee> employees = employeeDAO.getEmployeesByProject(projectId);
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=Project_" + projectId + "_Report.pdf");

                Document document = new Document();
                try {
                    PdfWriter.getInstance(document, response.getOutputStream());
                    document.open();
                    document.add(new Paragraph("Project Report: " + project.getProjectName()));
                    document.add(new Paragraph(" "));
                    document.add(new Paragraph("Details:"));
                    document.add(new Paragraph("  Name: " + project.getProjectName()));
                    document.add(new Paragraph("  Description: " + project.getDescription()));
                    document.add(new Paragraph("  Start Date: " + project.getStartDate()));
                    document.add(new Paragraph("  End Date: " + project.getEndDate()));
                    document.add(new Paragraph("  Status: " + project.getStatus()));
                    document.add(new Paragraph("  Priority: " + project.getPriority()));
                    document.add(new Paragraph(" "));
                    document.add(new Paragraph("Team Leaders (" + teamLeaders.size() + "):"));
                    for (TeamLeader tl : teamLeaders) {
                        document.add(new Paragraph("  - " + tl.getName()));
                    }
                    document.add(new Paragraph(" "));
                    document.add(new Paragraph("Employees (" + employees.size() + "):"));
                    for (Employee emp : employees) {
                        document.add(new Paragraph("  - " + emp.getName()));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    document.close();
                }
                return;
            }
        } else if ("create-projects".equals(contentType)) {
            // No changes
        } else if ("assign-team-leaders".equals(contentType)) {
            List<TeamLeader> teamLeaders = teamLeaderDAO.getAllTeamLeaders();
            List<Project> projects = projectDAO.getAllProjects();
            Map<Integer, List<TeamLeader>> assignedTeamLeadersMap = new HashMap<>();
            for (Project p : projects) {
                assignedTeamLeadersMap.put(p.getProjectId(), projectDAO.getAssignedTeamLeaders(p.getProjectId()));
            }
            request.setAttribute("teamLeaders", teamLeaders);
            request.setAttribute("projects", projects);
            request.setAttribute("assignedTeamLeadersMap", assignedTeamLeadersMap);
        }
        request.getRequestDispatcher("views/dashboards/admin/admin-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/Projects?contentType=assign-team-leaders";
        DashboardStats stats = (DashboardStats) session.getAttribute("stats");
        if (stats == null) {
            stats = new DashboardStats();
            updateStats(stats);
            session.setAttribute("stats", stats);
        }

        try {
        	if ("createProject".equals(action)) {
        	    Project project = new Project();
        	    project.setProjectName(request.getParameter("projectName"));
        	    project.setDescription(request.getParameter("description"));
        	    project.setStartDate(Date.valueOf(request.getParameter("startDate")));
        	    project.setEndDate(Date.valueOf(request.getParameter("endDate")));
        	    project.setStatus("Ongoing");
        	    project.setPriority(request.getParameter("priority"));
        	    project.setAdminId(1);

        	    int projectId = projectDAO.createProject(project);
        	    if (projectId == -1) {
        	        session.setAttribute("error", "Failed to create project.");
        	        response.sendRedirect(request.getContextPath() + "/DashboardServlet?contentType=welcome");
        	        return;
        	    }

        	    String[] teamLeaderIds = request.getParameterValues("teamLeaderIds");
        	    if (teamLeaderIds != null) {
        	        for (String tlId : teamLeaderIds) {
        	            int teamLeaderId = Integer.parseInt(tlId);
        	            projectDAO.assignTeamLeader(projectId, teamLeaderId);
        	        }
        	    }

        	    updateStats(stats);
        	    session.setAttribute("stats", stats);
        	    session.setAttribute("message", "Project created successfully with ID: " + projectId);
        	    response.sendRedirect(request.getContextPath() + "/DashboardServlet?contentType=welcome");
        	}else if ("complete".equals(action)) {
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                Project project = projectDAO.getProjectById(projectId);
                if ("Ongoing".equals(project.getStatus())) {
                    projectDAO.updateProjectStatus(projectId, "Completed");
                    projectDAO.updateProjectProgress(projectId, 100); // Set progress to 100%
                    updateStats(stats);
                    session.setAttribute("stats", stats);
                    session.setAttribute("message", "Project marked as completed!");
                } else {
                    session.setAttribute("error", "Project is already completed.");
                }
                // Redirect to project details page
                response.sendRedirect(request.getContextPath() + "/Projects?contentType=view-projects&action=view&projectId=" + projectId);
            }else if ("updateProject".equals(action)) {
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                Project project = projectDAO.getProjectById(projectId);
                project.setProjectName(request.getParameter("projectName"));
                project.setDescription(request.getParameter("description"));
                projectDAO.updateProject(project);
                updateStats(stats);
                session.setAttribute("stats", stats);
                response.sendRedirect(request.getContextPath() + "/DashboardServlet?contentType=welcome");
            } else if ("assignTeamLeader".equals(action)) {
                int teamLeaderId = Integer.parseInt(request.getParameter("teamLeaderId"));
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                boolean success = projectDAO.assignTeamLeader(projectId, teamLeaderId);
                if (success) {
                    session.setAttribute("message", "Team leader assigned successfully!");
                } else {
                    session.setAttribute("error", "Failed to assign team leader.");
                }
                response.sendRedirect(redirectUrl);
            } else if ("removeTeamLeader".equals(action)) {
                int teamLeaderId = Integer.parseInt(request.getParameter("teamLeaderId"));
                int projectId = Integer.parseInt(request.getParameter("projectId"));
                boolean success = projectDAO.removeTeamLeader(projectId, teamLeaderId);
                if (success) {
                    session.setAttribute("message", "Team leader removed successfully!");
                } else {
                    session.setAttribute("error", "Failed to remove team leader.");
                }
                response.sendRedirect(redirectUrl);
            }
        } catch (Exception e) {
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(redirectUrl);
        }
    }

    private void updateStats(DashboardStats stats) {
        stats.setProjectCount(projectDAO.getAllProjects().size());
        stats.setPendingTaskCount(projectDAO.getProjectsByStatus("Ongoing").size());
        stats.setCompletedTaskCount(projectDAO.getProjectsByStatus("Completed").size());
        int total = stats.getCompletedTaskCount() + stats.getPendingTaskCount();
        stats.setProductivity(total > 0 ? (stats.getCompletedTaskCount() * 100.0) / total : 0);
        stats.setAdminCount(1);
    }
}