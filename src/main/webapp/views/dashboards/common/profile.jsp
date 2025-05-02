<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .profile-container { max-width: 700px; margin: 50px auto; padding: 20px; background: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        .btn-primary { width: 100%; }
        .alert { margin-top: 15px; }
        .profile-picture { max-width: 150px; border-radius: 50%; }
        .password-section { margin-top: 20px; border-top: 1px solid #ddd; padding-top: 20px; }
    </style>
</head>
<body>
    <div class="profile-container">
        <h2 class="text-center">Your Profile</h2>
        <%
            String message = (String) request.getAttribute("message");
            String alertType = (String) request.getAttribute("alertType");
            if (message != null) {
        %>
            <div class="alert alert-<%= alertType %>"><%= message %></div>
        <%
            }
            Object user = request.getAttribute("user");
            String role = (String) session.getAttribute("role");
            String userId = (String) session.getAttribute("userId");

            if (user == null || role == null || userId == null) {
        %>
            <div class="alert alert-danger">
                Error: <% if (user == null) { %>User data not found<% } %>
                <% if (role == null) { %><%= user == null ? " and " : "" %>Role missing<% } %>
                <% if (userId == null) { %><%= (user == null || role == null) ? " and " : "" %>User ID missing<% } %>.
                Please try again or contact support.
            </div>
            <a href="<%= request.getContextPath() %>/dashboards/employee/EmployeeDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        <%
                return;
            }
        %>
        <form action="<%= request.getContextPath() %>/EmployeeProfileServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="role" value="<%= role %>">
            <input type="hidden" name="userId" value="<%= userId %>">

            <!-- Profile Picture -->
            <div class="form-group text-center">
                <label>Profile Picture</label><br>
                <%
                    String profilePicture = user instanceof in.efficio.model.Employee ? ((in.efficio.model.Employee) user).getProfile_picture() :
                                            user instanceof in.efficio.model.TeamLeader ? ((in.efficio.model.TeamLeader) user).getProfile_picture() :
                                            user instanceof in.efficio.model.SuperAdmin ? ((in.efficio.model.SuperAdmin) user).getProfile_picture() : "";
                    if (profilePicture != null && !profilePicture.isEmpty()) {
                %>
                    <img src="<%= request.getContextPath() %>/<%= profilePicture %>" class="profile-picture" alt="Profile Picture"><br>
                <%
                    }
                %>
                <input type="file" class="form-control-file" name="profile_picture" accept="image/*">
            </div>

            <!-- Common Fields -->
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" class="form-control" id="name" name="name" value="<%= user instanceof in.efficio.model.Employee ? ((in.efficio.model.Employee) user).getName() :
                                                                                   user instanceof in.efficio.model.TeamLeader ? ((in.efficio.model.TeamLeader) user).getName() :
                                                                                   user instanceof in.efficio.model.SuperAdmin ? ((in.efficio.model.SuperAdmin) user).getName() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" class="form-control" id="email" name="email" value="<%= user instanceof in.efficio.model.Employee ? ((in.efficio.model.Employee) user).getEmail() :
                                                                                       user instanceof in.efficio.model.TeamLeader ? ((in.efficio.model.TeamLeader) user).getEmail() :
                                                                                       user instanceof in.efficio.model.SuperAdmin ? ((in.efficio.model.SuperAdmin) user).getEmail() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="mobile_number">Mobile Number</label>
                <input type="text" class="form-control" id="mobile_number" name="mobile_number" value="<%= user instanceof in.efficio.model.Employee ? ((in.efficio.model.Employee) user).getMobile_number() :
                                                                                                    user instanceof in.efficio.model.TeamLeader ? ((in.efficio.model.TeamLeader) user).getMobile_number() :
                                                                                                    user instanceof in.efficio.model.SuperAdmin ? ((in.efficio.model.SuperAdmin) user).getMobile_number() : "" %>">
            </div>
            <div class="form-group">
                <label for="bio">Bio</label>
                <textarea class="form-control" id="bio" name="bio"><%= user instanceof in.efficio.model.Employee ? ((in.efficio.model.Employee) user).getBio() :
                                                                      user instanceof in.efficio.model.TeamLeader ? ((in.efficio.model.TeamLeader) user).getBio() :
                                                                      user instanceof in.efficio.model.SuperAdmin ? ((in.efficio.model.SuperAdmin) user).getBio() : "" %></textarea>
            </div>
            <div class="form-group">
                <label for="address">Address</label>
                <input type="text" class="form-control" id="address" name="address" value="<%= user instanceof in.efficio.model.Employee ? ((in.efficio.model.Employee) user).getAddress() :
                                                                                            user instanceof in.efficio.model.TeamLeader ? ((in.efficio.model.TeamLeader) user).getAddress() :
                                                                                            user instanceof in.efficio.model.SuperAdmin ? ((in.efficio.model.SuperAdmin) user).getAddress() : "" %>">
            </div>

            <!-- Role-Specific Fields -->
            <%
                if ("Employee".equals(role) || "TeamLeader".equals(role)) {
            %>
                <div class="form-group">
                    <label for="skills">Skills</label>
                    <textarea class="form-control" id="skills" name="skills"><%= user instanceof in.efficio.model.Employee ? ((in.efficio.model.Employee) user).getSkills() :
                                                                                user instanceof in.efficio.model.TeamLeader ? ((in.efficio.model.TeamLeader) user).getSkills() : "" %></textarea>
                </div>
                <div class="form-group">
                    <label for="dob">Date of Birth</label>
                    <input type="date" class="form-control" id="dob" name="dob" value="<%= user instanceof in.efficio.model.Employee && ((in.efficio.model.Employee) user).getDob() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(((in.efficio.model.Employee) user).getDob()) :
                                                                                          user instanceof in.efficio.model.TeamLeader && ((in.efficio.model.TeamLeader) user).getDob() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(((in.efficio.model.TeamLeader) user).getDob()) : "" %>">
                </div>
            <%
                }
                if ("Employee".equals(role)) {
            %>
                <div class="form-group">
                    <label for="department">Department</label>
                    <input type="text" class="form-control" id="department" name="department" value="<%= ((in.efficio.model.Employee) user).getDept_name() %>" readonly>
                </div>
                <div class="form-group">
                    <label for="rating">Rating</label>
                    <input type="text" class="form-control" id="rating" name="rating" value="<%= ((in.efficio.model.Employee) user).getRating() %>" readonly>
                </div>
            <%
                }
                if ("TeamLeader".equals(role)) {
            %>
                <div class="form-group">
                    <label for="department">Department</label>
                    <input type="text" class="form-control" id="department" name="department" value="<%= ((in.efficio.model.TeamLeader) user).getDepartment_name() %>" readonly>
                </div>
                <div class="form-group">
                    <label for="assigned_project">Assigned Project</label>
                    <input type="text" class="form-control" id="assigned_project" name="assigned_project" value="<%= ((in.efficio.model.TeamLeader) user).getAssign_project_name() %>" readonly>
                </div>
            <%
                }
            %>

            <!-- Password Update Section -->
            <div class="password-section">
                <h4>Update Password</h4>
                <div class="form-group">
                    <label for="new_password">New Password</label>
                    <input type="password" class="form-control" id="new_password" name="new_password">
                </div>
                <div class="form-group">
                    <label for="confirm_password">Confirm New Password</label>
                    <input type="password" class="form-control" id="confirm_password" name="confirm_password">
                </div>
            </div>

            <button type="submit" class="btn btn-primary">Update Profile</button>
        </form>
        <a href="<%= request.getContextPath() %>/dashboards/<%= role.toLowerCase() %>/<%= role %>Dashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
    <script>
        document.querySelector('form').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('new_password').value;
            const confirmPassword = document.getElementById('confirm_password').value;
            if (newPassword && newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
            const mobile = document.getElementById('mobile_number').value;
            if (mobile && !/^\d{10}$/.test(mobile)) {
                e.preventDefault();
                alert('Mobile number must be 10 digits!');
            }
        });
    </script>
</body>
</html>