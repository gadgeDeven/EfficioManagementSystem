package in.efficio.model;

import java.sql.Date;

public class Feedback {
    private int feedId;
    private int employeeId;
    private String feedbackText;
    private Date date;
    private boolean isSeen;
    private String filePath;

    // Getters and Setters
    public int getFeedId() { return feedId; }
    public void setFeedId(int feedId) { this.feedId = feedId; }
    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }
    public String getFeedbackText() { return feedbackText; }
    public void setFeedbackText(String feedbackText) { this.feedbackText = feedbackText; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    public boolean isSeen() { return isSeen; }
    public void setSeen(boolean seen) { isSeen = seen; }
    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
}