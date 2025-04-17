package in.efficio.model;

public class DashboardStats {
    private int teamSize;
    private int projectCount;
    private int pendingProjectCount;
    private int completedProjectCount;
    private int taskCount;
    private int pendingTaskCount;
    private int completedTaskCount;
    private double productivity;
    private int adminCount; // For admin dashboard

    // Default constructor
    public DashboardStats() {}

    // Getters and Setters
    public int getTeamSize() { return teamSize; }
    public void setTeamSize(int teamSize) { this.teamSize = teamSize; }
    public int getProjectCount() { return projectCount; }
    public void setProjectCount(int projectCount) { this.projectCount = projectCount; }
    public int getPendingProjectCount() { return pendingProjectCount; }
    public void setPendingProjectCount(int pendingProjectCount) { this.pendingProjectCount = pendingProjectCount; }
    public int getCompletedProjectCount() { return completedProjectCount; }
    public void setCompletedProjectCount(int completedProjectCount) { this.completedProjectCount = completedProjectCount; }
    public int getTaskCount() { return taskCount; }
    public void setTaskCount(int taskCount) { this.taskCount = taskCount; }
    public int getPendingTaskCount() { return pendingTaskCount; }
    public void setPendingTaskCount(int pendingTaskCount) { this.pendingTaskCount = pendingTaskCount; }
    public int getCompletedTaskCount() { return completedTaskCount; }
    public void setCompletedTaskCount(int completedTaskCount) { this.completedTaskCount = completedTaskCount; }
    public double getProductivity() { return productivity; }
    public void setProductivity(double productivity) { this.productivity = productivity; }
    public int getAdminCount() { return adminCount; }
    public void setAdminCount(int adminCount) { this.adminCount = adminCount; }
}