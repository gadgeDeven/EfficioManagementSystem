package in.efficio.model;

import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private int teamleaderId;
    private String type;
    private String message;
    private Integer projectId;
    private Integer taskId;
    private boolean isSeen;
    private Timestamp createdAt;

    // Constructors
    public Notification() {}

    public Notification(int teamleaderId, String type, String message, Integer projectId, Integer taskId, boolean isSeen) {
        this.teamleaderId = teamleaderId;
        this.type = type;
        this.message = message;
        this.projectId = projectId;
        this.taskId = taskId;
        this.isSeen = isSeen;
    }

    // Getters and Setters
    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }
    public int getTeamleaderId() { return teamleaderId; }
    public void setTeamleaderId(int teamleaderId) { this.teamleaderId = teamleaderId; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public Integer getProjectId() { return projectId; }
    public void setProjectId(Integer projectId) { this.projectId = projectId; }
    public Integer getTaskId() { return taskId; }
    public void setTaskId(Integer taskId) { this.taskId = taskId; }
    public boolean isSeen() { return isSeen; }
    public void setSeen(boolean seen) { this.isSeen = seen; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}