package in.efficio.model;

public class SuperAdmin {
    private int employee_id;
    private String name;
    private String email;
    private String mobile_number;
    private String bio;
    private String address;
    private String profile_picture;

    public int getEmployee_id() { return employee_id; }
    public void setEmployee_id(int employee_id) { this.employee_id = employee_id; }
    public String getName() { return name != null ? name : ""; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email != null ? email : ""; }
    public void setEmail(String email) { this.email = email; }
    public String getMobile_number() { return mobile_number != null ? mobile_number : ""; }
    public void setMobile_number(String mobile_number) { this.mobile_number = mobile_number; }
    public String getBio() { return bio != null ? bio : ""; }
    public void setBio(String bio) { this.bio = bio; }
    public String getAddress() { return address != null ? address : ""; }
    public void setAddress(String address) { this.address = address; }
    public String getProfile_picture() { return profile_picture != null ? profile_picture : ""; }
    public void setProfile_picture(String profile_picture) { this.profile_picture = profile_picture; }

    @Override
    public String toString() {
        return "SuperAdmin{id=" + employee_id + ", name=" + name + ", email=" + email + "}";
    }
}