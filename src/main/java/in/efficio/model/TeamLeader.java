package in.efficio.model;

import java.util.Date;
import java.util.List;

public class TeamLeader {
    private int employee_id; // Changed from teamleader_id for consistency
    private String name;
    private String email;
    private String skills;
    private Date dob;
    private String department_name;
    private String assign_project_name;
    private int assignProject_id;
    private String status;
    private List<Project> projects;
    // Added fields for profile.jsp compatibility
    private String profile_picture;
    private String bio;
    private String address;
    private String mobile_number;

    public int getEmployee_id() { return employee_id; }
    public void setEmployee_id(int employee_id) { this.employee_id = employee_id; }
    // For backward compatibility
    public int getTeamleader_id() { return employee_id; }
    public void setTeamleader_id(int teamleader_id) { this.employee_id = teamleader_id; }
    public String getName() { return name != null ? name : ""; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email != null ? email : ""; }
    public void setEmail(String email) { this.email = email; }
    public String getSkills() { return skills != null ? skills : ""; }
    public void setSkills(String skills) { this.skills = skills; }
    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }
    public String getDepartment_name() { return department_name != null ? department_name : ""; }
    public void setDepartment_name(String department_name) { this.department_name = department_name; }
    public String getAssign_project_name() { return assign_project_name != null ? assign_project_name : ""; }
    public void setAssign_project_name(String assign_project_name) { this.assign_project_name = assign_project_name; }
    public int getAssignProject_id() { return assignProject_id; }
    public void setAssignProject_id(int assignProject_id) { this.assignProject_id = assignProject_id; }
    public String getStatus() { return status != null ? status : ""; }
    public void setStatus(String status) { this.status = status; }
    public List<Project> getProjects() { return projects; }
    public void setProjects(List<Project> projects) { this.projects = projects; }
    public String getProfile_picture() { return profile_picture != null ? profile_picture : ""; }
    public void setProfile_picture(String profile_picture) { this.profile_picture = profile_picture; }
    public String getBio() { return bio != null ? bio : ""; }
    public void setBio(String bio) { this.bio = bio; }
    public String getAddress() { return address != null ? address : ""; }
    public void setAddress(String address) { this.address = address; }
    public String getMobile_number() { return mobile_number != null ? mobile_number : ""; }
    public void setMobile_number(String mobile_number) { this.mobile_number = mobile_number; }

    @Override
    public String toString() {
        return "TeamLeader{id=" + employee_id + ", name=" + name + ", email=" + email + "}";
    }
}