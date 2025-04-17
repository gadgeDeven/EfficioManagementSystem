package in.efficio.model;

import java.sql.Date;

public class Project {
    private int projectId;
    private String projectName;
    private String description;
    private Date startDate;
    private Date endDate;
    private String status;
    private String priority;
    private int adminId;
    private String teamLeaderName;
    private Integer teamLeaderId ;
    


	public Project(int projectId, String projectName,Integer teamLeaderId, String teamLeaderName ) {
		super();
		this.projectId = projectId;
		this.projectName = projectName;
		this.teamLeaderId = teamLeaderId;
		this.teamLeaderName = teamLeaderName;
	}



	// Default constructor
    public Project() {}
    
    

    // Parameterized constructor
    public Project(int projectId, String projectName, String description, Date startDate, 
                   Date endDate, String status, String priority, int adminId) {
        this.projectId = projectId;
        this.projectName = projectName;
        this.description = description;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.priority = priority;
        this.adminId = adminId;
    }

    // Getters and Setters
    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }
    public String getProjectName() { return projectName; }
    public void setProjectName(String projectName) { this.projectName = projectName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }
    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }
    public String getTeamLeaderName() { return teamLeaderName; }
    public void setTeamLeaderName(String teamLeaderName) { this.teamLeaderName = teamLeaderName; }
    public int getTeamLeaderId() {
		return teamLeaderId;
	}

	public void setTeamLeaderId(Integer teamLeaderId) {
		this.teamLeaderId = teamLeaderId;
	}
}