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
    private String mobileNumber;
    // Added fields for profile.jsp compatibility
    private String profile_picture;
    private String bio;
    private String address;

    public String getMobileNumber() { return mobileNumber; }
    public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }
    // Alias for profile.jsp
    public String getMobile_number() { return mobileNumber; }
    public void setMobile_number(String mobileNumber) { this.mobileNumber = mobileNumber; }

    public int getEmployee_id() { return employee_id; }
    public void setEmployee_id(int employee_id) { this.employee_id = employee_id; }
    public String getName() { return name != null ? name : ""; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email != null ? email : ""; }
    public void setEmail(String email) { this.email = email; }
    public String getSkills() { return skills != null ? skills : ""; }
    public void setSkills(String skills) { this.skills = skills; }
    public float getRating() { return rating; }
    public void setRating(float rating) { this.rating = rating; }
    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }
    public String getDept_name() { return dept_name != null ? dept_name : ""; }
    public void setDept_name(String dept_name) { this.dept_name = dept_name; }
    public String getTeamLeader_name() { return teamLeader_name != null ? teamLeader_name : ""; }
    public void setTeamLeader_name(String teamLeader_name) { this.teamLeader_name = teamLeader_name; }
    public String getAssign_project_name() { return assign_project_name != null ? assign_project_name : ""; }
    public void setAssign_project_name(String assign_project_name) { this.assign_project_name = assign_project_name; }
    public String getStatus() { return status != null ? status : ""; }
    public int getAssign_project_id() { return assign_project_id; }
    public void setAssign_project_id(int assign_project_id) { this.assign_project_id = assign_project_id; }
    public void setStatus(String status) { this.status = status; }
    public List<Project> getProjects() { return projects; }
    public void setProjects(List<Project> projects) { this.projects = projects; }
    public Set<Integer> getTeamLeaderIds() { return teamLeaderIds; }
    public void setTeamLeaderIds(Set<Integer> teamLeaderIds) { this.teamLeaderIds = teamLeaderIds; }
    public List<Task> getTasks() { return tasks; }
    public void setTasks(List<Task> tasks) { this.tasks = tasks; }
    public String getProfile_picture() { return profile_picture != null ? profile_picture : ""; }
    public void setProfile_picture(String profile_picture) { this.profile_picture = profile_picture; }
    public String getBio() { return bio != null ? bio : ""; }
    public void setBio(String bio) { this.bio = bio; }
    public String getAddress() { return address != null ? address : ""; }
    public void setAddress(String address) { this.address = address; }

    @Override
    public String toString() {
        return "Employee{id=" + employee_id + ", name=" + name + ", email=" + email + "}";
    }
}