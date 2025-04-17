package in.efficio.controllers;

import in.efficio.dao.EmployeeDAO;
import in.efficio.dao.ProjectDAO;
import in.efficio.dao.TaskDAO;
import in.efficio.dbconnection.DbConnection;
import in.efficio.model.Employee;
import in.efficio.model.Project;
import in.efficio.model.Task;
import in.efficio.model.DashboardStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet("/TeamLeaderDashboard")
public class TeamLeaderDashboard extends HttpServlet {
	private EmployeeDAO employeeDAO;
	private ProjectDAO projectDAO;
	private TaskDAO taskDAO;

	@Override
	public void init() {
		employeeDAO = new EmployeeDAO();
		projectDAO = new ProjectDAO();
		taskDAO = new TaskDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userName") == null) {
			response.sendRedirect(
					request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
			return;
		}

		String teamLeaderEmail = (String) session.getAttribute("userName");
		String displayName = (String) session.getAttribute("displayName");
		int teamLeaderId = projectDAO.getTeamLeaderIdByEmail(teamLeaderEmail);
		if (teamLeaderId == -1) {
			response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Invalid Team Leader.");
			return;
		}

		String contentType = request.getParameter("contentType");
		if (contentType == null)
			contentType = "welcome";

		// Prepare DashboardStats
		DashboardStats stats = new DashboardStats();
		updateStats(stats, teamLeaderId);
		request.setAttribute("stats", stats);

		// Handle different content types
		if ("welcome".equals(contentType)) {
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("projects".equals(contentType)) {
			String projectIdStr = request.getParameter("projectId");
			List<Project> projects = projectDAO.getProjects(teamLeaderId);
			Project selectedProject = null;
			if (projectIdStr != null && !projectIdStr.isEmpty()) {
				try {
					int projectId = Integer.parseInt(projectIdStr);
					selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst()
							.orElse(null);
					if (selectedProject == null) {
						request.setAttribute("errorMessage", "Project not found or not assigned to you.");
					}
				} catch (NumberFormatException e) {
					request.setAttribute("errorMessage", "Invalid project ID.");
				}
			}
			request.setAttribute("projects", projects);
			request.setAttribute("selectedProject", selectedProject);
			request.setAttribute("includePath", "projects.jsp"); // Set includePath
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("pending-projects".equals(contentType)) {
			String projectIdStr = request.getParameter("projectId");
			List<Project> projects = projectDAO.getProjectsByStatusTeam(teamLeaderId, "Ongoing");
			Project selectedProject = null;
			if (projectIdStr != null && !projectIdStr.isEmpty()) {
				try {
					int projectId = Integer.parseInt(projectIdStr);
					selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst()
							.orElse(null);
					if (selectedProject == null) {
						request.setAttribute("errorMessage", "Pending project not found or not assigned to you.");
					}
				} catch (NumberFormatException e) {
					request.setAttribute("errorMessage", "Invalid project ID.");
				}
			}
			request.setAttribute("projects", projects);
			request.setAttribute("selectedProject", selectedProject);
			request.setAttribute("includePath", "projects.jsp"); // Set includePath
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("completed-projects".equals(contentType)) {
			String projectIdStr = request.getParameter("projectId");
			List<Project> projects = projectDAO.getProjectsByStatusTeam(teamLeaderId, "Completed");
			Project selectedProject = null;
			if (projectIdStr != null && !projectIdStr.isEmpty()) {
				try {
					int projectId = Integer.parseInt(projectIdStr);
					selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst()
							.orElse(null);
					if (selectedProject == null) {
						request.setAttribute("errorMessage", "Completed project not found or not assigned to you.");
					}
				} catch (NumberFormatException e) {
					request.setAttribute("errorMessage", "Invalid project ID.");
				}
			}
			request.setAttribute("projects", projects);
			request.setAttribute("selectedProject", selectedProject);
			request.setAttribute("includePath", "projects.jsp"); // Set includePath
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("tasks".equals(contentType)) {
			List<Task> tasks = taskDAO.getTasksByTeamLeader(teamLeaderId);
			List<Project> projects = projectDAO.getProjects(teamLeaderId);
			List<Employee> teamMembers = employeeDAO.getTeamMembers(displayName);
			request.setAttribute("tasks", tasks);
			request.setAttribute("projects", projects);
			request.setAttribute("teamMembers", teamMembers);
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("pending-tasks".equals(contentType)) {
			List<Task> pendingTasks = taskDAO.getTasksByStatus(teamLeaderId, "Pending");
			request.setAttribute("pendingTasks", pendingTasks);
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("completed-tasks".equals(contentType)) {
			List<Task> completedTasks = taskDAO.getTasksByStatus(teamLeaderId, "Completed");
			request.setAttribute("completedTasks", completedTasks);
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("create-task".equals(contentType)) {
			List<Project> projects = projectDAO.getProjects(teamLeaderId);
			request.setAttribute("projects", projects);
			if (projects == null || projects.isEmpty()) {
				request.setAttribute("errorMessage", "No projects available to create tasks.");
			}
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("assign-task".equals(contentType)) {
			List<Project> projects = projectDAO.getProjects(teamLeaderId);
			List<Task> tasks = new ArrayList<>();
			List<Employee> teamMembers = new ArrayList<>();
			String selectedProjectId = request.getParameter("projectId");
			if (selectedProjectId != null && !selectedProjectId.isEmpty()) {
				try {
					int projectId = Integer.parseInt(selectedProjectId);
					boolean validProject = projects.stream().anyMatch(p -> p.getProjectId() == projectId);
					if (!validProject) {
						request.setAttribute("errorMessage", "Selected project is not assigned to you.");
					} else {
						tasks = taskDAO.getTasksByProject(projectId, teamLeaderId);
						teamMembers = employeeDAO.getEmployeesByProject(projectId);
						if (tasks.isEmpty()) {
							request.setAttribute("errorMessage", "No tasks found for project ID: " + projectId);
						}
						if (teamMembers.isEmpty()) {
							request.setAttribute("employeeErrorMessage",
									"No employees assigned to this project. Please assign employees first.");
						}
					}
				} catch (NumberFormatException e) {
					request.setAttribute("errorMessage", "Invalid project ID.");
				}
			}
			request.setAttribute("projects", projects);
			request.setAttribute("tasks", tasks);
			request.setAttribute("teamMembers", teamMembers);
			request.setAttribute("selectedProjectId", selectedProjectId);
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("assign-projects".equals(contentType)) {
			List<Project> projects = projectDAO.getProjects(teamLeaderId);
			Project selectedProject = null;
			List<Employee> allEmployees = employeeDAO.getAllEmployees();
			List<Employee> assignedEmployees = new ArrayList<>();
			String projectIdStr = request.getParameter("projectId");
			if (projectIdStr != null && !projectIdStr.isEmpty()) {
				try {
					int projectId = Integer.parseInt(projectIdStr);
					selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst()
							.orElse(null);
					if (selectedProject == null) {
						request.setAttribute("errorMessage", "Selected project is not assigned to you.");
					} else {
						assignedEmployees = employeeDAO.getEmployeesByProject(projectId);
					}
				} catch (NumberFormatException e) {
					request.setAttribute("errorMessage", "Invalid project ID.");
				}
			}
			request.setAttribute("projects", projects);
			request.setAttribute("selectedProject", selectedProject);
			request.setAttribute("allEmployees", allEmployees);
			request.setAttribute("assignedEmployees", assignedEmployees);
			request.setAttribute("includePath", "assign-projects.jsp"); // Set includePath
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("team-members".equals(contentType)) {
			List<Employee> teamMembers = employeeDAO.getTeamMembers(displayName);
			request.setAttribute("teamMembers", teamMembers);
			request.setAttribute("teamMemberCount", teamMembers.size());
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("productivity".equals(contentType)) {
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("notifications".equals(contentType)) {
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("employee-details".equals(contentType)) {
			String employeeIdStr = request.getParameter("employeeId");
			String projectIdStr = request.getParameter("projectId");
			Employee employee = null;
			boolean isAssigned = false;
			if (employeeIdStr != null && !employeeIdStr.isEmpty()) {
				try {
					int employeeId = Integer.parseInt(employeeIdStr);
					Optional<Employee> empOptional = employeeDAO.getEmployeeById(employeeId);
					if (empOptional.isPresent()) {
						employee = empOptional.get();
						if (projectIdStr != null && !projectIdStr.isEmpty()) {
							int projectId = Integer.parseInt(projectIdStr);
							isAssigned = employeeDAO.isEmployeeAssignedToProject(employeeId, projectId);
						}
					} else {
						request.setAttribute("errorMessage", "Employee not found.");
					}
				} catch (NumberFormatException e) {
					request.setAttribute("errorMessage", "Invalid employee or project ID.");
				}
			} else {
				request.setAttribute("errorMessage", "No employee selected.");
			}
			request.setAttribute("employee", employee);
			request.setAttribute("isAssigned", isAssigned);
			request.setAttribute("includePath", "employee-details.jsp"); // Set includePath
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else if ("tasks-by-project".equals(contentType)) {
			String projectIdStr = request.getParameter("projectId");
			Project selectedProject = null;
			List<Task> tasks = new ArrayList<>();
			List<Employee> teamMembers = employeeDAO.getTeamMembers(displayName);
			if (projectIdStr != null && !projectIdStr.isEmpty()) {
				try {
					int projectId = Integer.parseInt(projectIdStr);
					List<Project> projects = projectDAO.getProjects(teamLeaderId);
					selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst()
							.orElse(null);
					if (selectedProject == null) {
						request.setAttribute("errorMessage", "Project not assigned to you.");
					} else {
						tasks = taskDAO.getTasksByProject(projectId, teamLeaderId);
						if (tasks.isEmpty()) {
							request.setAttribute("errorMessage", "No tasks found for project ID: " + projectId);
						}
					}
				} catch (NumberFormatException e) {
					request.setAttribute("errorMessage", "Invalid project ID.");
				}
			}
			request.setAttribute("selectedProject", selectedProject);
			request.setAttribute("tasks", tasks);
			request.setAttribute("teamMembers", teamMembers);
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		} else {
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("userName") == null) {
			response.sendRedirect(
					request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
			return;
		}

		String teamLeaderEmail = (String) session.getAttribute("userName");
		int teamLeaderId = projectDAO.getTeamLeaderIdByEmail(teamLeaderEmail);
		if (teamLeaderId == -1) {
			response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Invalid Team Leader.");
			return;
		}

		String action = request.getParameter("action");

		if ("createTask".equals(action)) {
			try {
				String taskTitle = request.getParameter("taskTitle");
				String description = request.getParameter("description");
				String projectIdStr = request.getParameter("projectId");
				String deadlineDateStr = request.getParameter("deadlineDate");

				if (taskTitle == null || taskTitle.trim().isEmpty()) {
					throw new IllegalArgumentException("Task title is required.");
				}
				if (description == null || description.trim().isEmpty()) {
					throw new IllegalArgumentException("Description is required.");
				}
				if (projectIdStr == null || projectIdStr.trim().isEmpty()) {
					throw new IllegalArgumentException("Project selection is required.");
				}
				if (deadlineDateStr == null || deadlineDateStr.trim().isEmpty()) {
					throw new IllegalArgumentException("Deadline date is required.");
				}

				int projectId;
				try {
					projectId = Integer.parseInt(projectIdStr);
				} catch (NumberFormatException e) {
					throw new IllegalArgumentException("Invalid project ID.");
				}

				List<Project> projects = projectDAO.getProjects(teamLeaderId);
				boolean validProject = projects.stream().anyMatch(p -> p.getProjectId() == projectId);
				if (!validProject) {
					throw new IllegalArgumentException("Selected project is not assigned to you.");
				}

				Task task = new Task();
				task.setTaskTitle(taskTitle);
				task.setDescription(description);
				task.setProjectId(projectId);
				try {
					task.setDeadlineDate(Date.valueOf(deadlineDateStr));
				} catch (IllegalArgumentException e) {
					throw new IllegalArgumentException("Invalid deadline date format.");
				}
				task.setStatus("Pending");
				task.setProgressPercentage(0);
				task.setAssignByTeamLeaderId(teamLeaderId);

				boolean created = taskDAO.createTask(task, teamLeaderId);

				DashboardStats stats = new DashboardStats();
				updateStats(stats, teamLeaderId);
				session.setAttribute("stats", stats);

				if (created) {
					request.setAttribute("successMessage", "Task created successfully!");
				} else {
					request.setAttribute("errorMessage", "Failed to create task. Please try again.");
				}
				List<Task> tasks = taskDAO.getTasksByTeamLeader(teamLeaderId);
				request.setAttribute("tasks", tasks);
				request.setAttribute("projects", projects);
				request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
						response);
			} catch (IllegalArgumentException e) {
				request.setAttribute("errorMessage", e.getMessage());
				request.setAttribute("projects", projectDAO.getProjects(teamLeaderId));
				request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
						response);
			} catch (Exception e) {
				request.setAttribute("errorMessage", "Unexpected error creating task: " + e.getMessage());
				request.setAttribute("projects", projectDAO.getProjects(teamLeaderId));
				request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
						response);
			}
		} else if ("assignTask".equals(action)) {
            try {
                String taskIdStr = request.getParameter("taskId");
                String employeeIdStr = request.getParameter("employeeId");
                String projectIdStr = request.getParameter("projectId");

                int taskId = Integer.parseInt(taskIdStr);
                int employeeId = Integer.parseInt(employeeIdStr);
                int projectId = Integer.parseInt(projectIdStr);

                // Validate inputs
                Task task = taskDAO.getTaskById(taskId);
                if (task == null || task.getProjectId() != projectId) {
                    request.setAttribute("errorMessage", "Invalid task or project.");
                } else if (!projectDAO.getProjects(teamLeaderId).stream()
                        .anyMatch(p -> p.getProjectId() == projectId)) {
                    request.setAttribute("errorMessage", "Project not assigned to you.");
                } else if (!employeeDAO.isEmployeeAssignedToProject(employeeId, projectId)) {
                    request.setAttribute("errorMessage", "Employee is not assigned to this project.");
                } else {
                    taskDAO.assignTaskToEmployee(taskId, employeeId, projectId, teamLeaderId);
                    request.setAttribute("successMessage", "Task assigned successfully.");
                }

                // Refresh assign-task.jsp
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                List<Task> tasks = taskDAO.getTasksByProject(projectId, teamLeaderId);
                List<Employee> teamMembers = employeeDAO.getEmployeesByProject(projectId);
                request.setAttribute("projects", projects);
                request.setAttribute("tasks", tasks);
                request.setAttribute("teamMembers", teamMembers);
                request.setAttribute("selectedProjectId", String.valueOf(projectId));
                request.setAttribute("includePath", "assign-task.jsp");
                request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
                        response);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid task, employee, or project ID.");
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                request.setAttribute("projects", projects);
                request.setAttribute("includePath", "assign-task.jsp");
                request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
                        response);
            } catch (RuntimeException e) {
                request.setAttribute("errorMessage", "Failed to assign task: " + e.getMessage());
                List<Project> projects = projectDAO.getProjects(teamLeaderId);
                request.setAttribute("projects", projects);
                request.setAttribute("includePath", "assign-task.jsp");
                request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
                        response);
            }
        } else if ("assignEmployee".equals(action)) {
			String projectIdStr = request.getParameter("projectId");
			String employeeIdStr = request.getParameter("employeeId");
			String assignAction = request.getParameter("assign");
			try {
				int projectId = Integer.parseInt(projectIdStr);
				int employeeId = Integer.parseInt(employeeIdStr);
				List<Project> projects = projectDAO.getProjects(teamLeaderId);
				Project selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst()
						.orElse(null);
				if (selectedProject == null) {
					request.setAttribute("errorMessage", "Selected project is not assigned to you.");
				} else {
					if ("add".equals(assignAction)) {
						employeeDAO.assignEmployeeToProject(employeeId, projectId, teamLeaderId);
						request.setAttribute("successMessage",
								"Employee assigned successfully to project: " + selectedProject.getProjectName());
					} else if ("remove".equals(assignAction)) {
						employeeDAO.removeEmployeeFromProject(employeeId, projectId);
						request.setAttribute("successMessage",
								"Employee removed successfully from project: " + selectedProject.getProjectName());
					}
				}
				List<Employee> allEmployees = employeeDAO.getAllEmployees();
				List<Employee> assignedEmployees = employeeDAO.getEmployeesByProject(projectId);
				request.setAttribute("projects", projects);
				request.setAttribute("selectedProject", selectedProject);
				request.setAttribute("allEmployees", allEmployees);
				request.setAttribute("assignedEmployees", assignedEmployees);
				request.setAttribute("includePath", "assign-projects.jsp"); // Set includePath
				request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
						response);
			} catch (NumberFormatException e) {
				request.setAttribute("errorMessage", "Invalid project or employee ID.");
				List<Project> projects = projectDAO.getProjects(teamLeaderId);
				request.setAttribute("projects", projects);
				request.setAttribute("includePath", "assign-projects.jsp"); // Set includePath
				request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
						response);
			} catch (RuntimeException e) {
				request.setAttribute("errorMessage", "Failed to process assignment: " + e.getMessage());
				List<Project> projects = projectDAO.getProjects(teamLeaderId);
				request.setAttribute("projects", projects);
				request.setAttribute("includePath", "assign-projects.jsp"); // Set includePath
				request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
						response);
			}
		} else if ("manageEmployees".equals(action)) {
			String projectIdStr = request.getParameter("projectId");
			String[] employeeIds = request.getParameterValues("employeeIds");
			try {
				int projectId = Integer.parseInt(projectIdStr);
				List<Integer> selectedEmployeeIds = new ArrayList<>();
				if (employeeIds != null) {
					for (String id : employeeIds) {
						selectedEmployeeIds.add(Integer.parseInt(id));
					}
				}
				employeeDAO.updateEmployeeAssignments(projectId, teamLeaderId, selectedEmployeeIds);
				request.setAttribute("successMessage", "Employee assignments updated successfully.");
				List<Project> projects = projectDAO.getProjects(teamLeaderId);
				Project selectedProject = projects.stream().filter(p -> p.getProjectId() == projectId).findFirst()
						.orElse(null);
				List<Employee> allEmployees = employeeDAO.getAllEmployees();
				List<Employee> assignedEmployees = employeeDAO.getEmployeesByProject(projectId);
				request.setAttribute("projects", projects);
				request.setAttribute("selectedProject", selectedProject);
				request.setAttribute("allEmployees", allEmployees);
				request.setAttribute("assignedEmployees", assignedEmployees);
				request.getRequestDispatcher("/views/dashboards/team-leader/assign-projects.jsp").forward(request,
						response);
			} catch (NumberFormatException e) {
				request.setAttribute("errorMessage", "Invalid project or employee IDs.");
				request.getRequestDispatcher("/views/dashboards/team-leader/assign-projects.jsp").forward(request,
						response);
			}
		} else {
			request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request,
					response);
		}
	}

	private void updateStats(DashboardStats stats, int teamLeaderId) {
		stats.setTeamSize(employeeDAO.getTeamSize(String.valueOf(teamLeaderId)));
		stats.setProjectCount(projectDAO.getProjectCount(teamLeaderId));
		stats.setPendingProjectCount(projectDAO.getProjectsByStatusTeam(teamLeaderId, "Ongoing").size());
		stats.setCompletedProjectCount(projectDAO.getProjectsByStatusTeam(teamLeaderId, "Completed").size());
		stats.setTaskCount(taskDAO.getTaskCount(teamLeaderId));
		stats.setPendingTaskCount(taskDAO.getPendingTaskCount(teamLeaderId));
		stats.setCompletedTaskCount(taskDAO.getCompletedTaskCount(teamLeaderId));
		int totalTasks = stats.getPendingTaskCount() + stats.getCompletedTaskCount();
		stats.setProductivity(totalTasks > 0 ? (stats.getCompletedTaskCount() * 100.0) / totalTasks : 0);
	}
}