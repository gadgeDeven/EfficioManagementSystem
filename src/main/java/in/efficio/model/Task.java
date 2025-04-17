package in.efficio.model;

import java.sql.Date;

public class Task {
    private int taskId;
    private String taskTitle;
    private String description;
    private int projectId;
    private Date deadlineDate;
    private String status;
    private int progressPercentage;
    private Integer assignByTeamLeaderId;
    private Integer assignedToEmployeeId;
    private String projectName; // For display

    // Getters and Setters
    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }

    public String getTaskTitle() { return taskTitle; }
    public void setTaskTitle(String taskTitle) { this.taskTitle = taskTitle; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }

    public Date getDeadlineDate() { return deadlineDate; }
    public void setDeadlineDate(Date deadlineDate) { this.deadlineDate = deadlineDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getProgressPercentage() { return progressPercentage; }
    public void setProgressPercentage(int progressPercentage) { this.progressPercentage = progressPercentage; }

    public Integer getAssignByTeamLeaderId() { return assignByTeamLeaderId; }
    public void setAssignByTeamLeaderId(Integer assignByTeamLeaderId) { this.assignByTeamLeaderId = assignByTeamLeaderId; }

    public Integer getAssignedToEmployeeId() { return assignedToEmployeeId; }
    public void setAssignedToEmployeeId(Integer assignedToEmployeeId) { this.assignedToEmployeeId = assignedToEmployeeId; }

    public String getProjectName() { return projectName; }
    public void setProjectName(String projectName) { this.projectName = projectName; }
}