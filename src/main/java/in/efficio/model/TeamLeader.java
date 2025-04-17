package in.efficio.model;

import java.util.Date;

public class TeamLeader {
    private int teamleader_id;
    private String name;
    private String email;
    private String skills;
    private Date dob;
    private String department_name;
    private String assign_project_name;
    private int assignProject_id;
    private String status;

    // Getters and Setters
    public int getTeamleader_id() {
        return teamleader_id;
    }
    public void setTeamleader_id(int teamleader_id) {
        this.teamleader_id = teamleader_id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getSkills() {
        return skills;
    }
    public void setSkills(String skills) {
        this.skills = skills;
    }
    public Date getDob() {
        return dob;
    }
    public void setDob(Date dob) {
        this.dob = dob;
    }
    public String getDepartment_name() {
        return department_name;
    }
    public void setDepartment_name(String department_name) {
        this.department_name = department_name;
    }
    public String getAssign_project_name() {
        return assign_project_name;
    }
    public void setAssign_project_name(String assign_project_name) {
        this.assign_project_name = assign_project_name;
    }
    
    public int getAssignProject_id() {
		return assignProject_id;
	}
	public void setAssignProject_id(int assignProject_id) {
		this.assignProject_id = assignProject_id;
	}
	public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
}