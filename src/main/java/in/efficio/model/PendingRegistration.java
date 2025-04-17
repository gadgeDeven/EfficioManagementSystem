package in.efficio.model;

public class PendingRegistration {
    private int id;
    private String role;
    private String name;
    private String email;
    private String department;
    private String status;
    private boolean isSeen;

    public PendingRegistration(int id, String role, String name, String email, String department, String status, boolean isSeen) {
        this.id = id;
        this.role = role;
        this.name = name;
        this.email = email;
        this.department = department;
        this.status = status;
        this.isSeen = isSeen;
    }

    // Getters
    public int getId() { return id; }
    public String getRole() { return role; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getDepartment() { return department; }
    public String getStatus() { return status; }
    public boolean isSeen() { return isSeen; }
}