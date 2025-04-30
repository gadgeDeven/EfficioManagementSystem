package in.efficio.model;

import java.sql.Date;
import java.util.List;

public class Task {
    private Integer taskId;
    private String taskTitle;
    private String description;
    private Integer projectId;
    private String projectName;
    private Date deadlineDate;
    private String status;
    private Integer progressPercentage;
    private Integer assignByTeamLeaderId;
    private Integer assignedToEmployeeId;
    private Boolean isSeen;
    private String teamLeaderName; // New field
    private List<Employee> employeesOnTask; // New field
    private String progressMessage; // New field

    // Getters and Setters
    public Integer getTaskId() { return taskId; }
    public void setTaskId(Integer taskId) { this.taskId = taskId; }
    public String getTaskTitle() { return taskTitle; }
    public void setTaskTitle(String taskTitle) { this.taskTitle = taskTitle; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Integer getProjectId() { return projectId; }
    public void setProjectId(Integer projectId) { this.projectId = projectId; }
    public String getProjectName() { return projectName; }
    public void setProjectName(String projectName) { this.projectName = projectName; }
    public Date getDeadlineDate() { return deadlineDate; }
    public void setDeadlineDate(Date deadlineDate) { this.deadlineDate = deadlineDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getProgressPercentage() { return progressPercentage; }
    public void setProgressPercentage(Integer progressPercentage) { this.progressPercentage = progressPercentage; }
    public Integer getAssignByTeamLeaderId() { return assignByTeamLeaderId; }
    public void setAssignByTeamLeaderId(Integer assignByTeamLeaderId) { this.assignByTeamLeaderId = assignByTeamLeaderId; }
    public Integer getAssignedToEmployeeId() { return assignedToEmployeeId; }
    public void setAssignedToEmployeeId(Integer assignedToEmployeeId) { this.assignedToEmployeeId = assignedToEmployeeId; }
    public Boolean getSeen() { return isSeen; }
    public void setSeen(Boolean seen) { isSeen = seen; }
    public String getTeamLeaderName() { return teamLeaderName; }
    public void setTeamLeaderName(String teamLeaderName) { this.teamLeaderName = teamLeaderName; }
    public List<Employee> getEmployeesOnTask() { return employeesOnTask; }
    public void setEmployeesOnTask(List<Employee> employeesOnTask) { this.employeesOnTask = employeesOnTask; }
    public String getProgressMessage() { return progressMessage; }
    public void setProgressMessage(String progressMessage) { this.progressMessage = progressMessage; }
}