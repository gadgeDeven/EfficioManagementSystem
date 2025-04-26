package in.efficio.model;

import java.util.Date;
import java.util.List;
import java.util.Set;

public class Employee {
    private int employee_id;
    private String name;
    private String email;
    private String skills;
    private float rating;
    private Date dob;
    private String dept_name;
    private String teamLeader_name;
    private int assign_project_id;
    private String assign_project_name;
    private String status;
    private List<Project> projects;
    private Set<Integer> teamLeaderIds;
    private List<Task> tasks;
    
    //Getter and Setters
	public int getEmployee_id() {
		return employee_id;
	}
	public void setEmployee_id(int employee_id) {
		this.employee_id = employee_id;
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
	public float getRating() {
		return rating;
	}
	public void setRating(float rating) {
		this.rating = rating;
	}
	public Date getDob() {
		return dob;
	}
	public void setDob(Date dob) {
		this.dob = dob;
	}
	public String getDept_name() {
		return dept_name;
	}
	public void setDept_name(String dept_name) {
		this.dept_name = dept_name;
	}
	public String getTeamLeader_name() {
		return teamLeader_name;
	}
	public void setTeamLeader_name(String teamLeader_name) {
		this.teamLeader_name = teamLeader_name;
	}
	
	public String getAssign_project_name() {
		return assign_project_name;
	}
	public void setAssign_project_name(String assign_project_name) {
		this.assign_project_name = assign_project_name;
	}
	public String getStatus() {
		return status;
	}
	public int getAssign_project_id() {
		return assign_project_id;
	}
	public void setAssign_project_id(int assign_project_id) {
		this.assign_project_id = assign_project_id;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public List<Project> getProjects() {
        return projects;
    }

    public void setProjects(List<Project> projects) {
        this.projects = projects;
    }
    public Set<Integer> getTeamLeaderIds() {
        return teamLeaderIds;
    }

    public void setTeamLeaderIds(Set<Integer> teamLeaderIds) {
        this.teamLeaderIds = teamLeaderIds;
    }
	public List<Task> getTasks() {
		return tasks;
	}
	public void setTasks(List<Task> tasks) {
		this.tasks = tasks;
	}
    
    
    
    //Getter and Setters
    
	
}
