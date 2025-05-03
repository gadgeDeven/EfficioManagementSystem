<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings | Efficio</title>
    <style>
        .settings-container {
            max-width: 900px;
            margin: 20px auto;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            font-family: 'Segoe UI', Arial, sans-serif;
        }
        .settings-container h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        .section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 6px;
        }
        .section h3 {
            color: #007bff;
            margin-bottom: 15px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            font-weight: 600;
            color: #444;
            margin-bottom: 5px;
        }
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        .form-group input:focus, .form-group textarea:focus {
            border-color: #007bff;
            outline: none;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        .profile-picture-container {
            text-align: center;
            margin-bottom: 20px;
        }
        .profile-picture {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #ddd;
        }
        .custom-file-upload {
            display: inline-block;
            padding: 8px 15px;
            background-color: #007bff;
            color: #fff;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .custom-file-upload:hover {
            background-color: #0056b3;
        }
        .form-group input[type="file"] {
            display: none;
        }
        .form-buttons {
            text-align: center;
            margin-top: 20px;
        }
        .form-buttons input[type="submit"], .form-buttons a {
            padding: 10px 20px;
            margin: 0 10px;
            text-decoration: none;
            color: #fff;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
        }
        .form-buttons input[type="submit"] {
            background-color: #28a745;
            border: none;
        }
        .form-buttons input[type="submit"]:hover {
            background-color: #218838;
        }
        .form-buttons a {
            background-color: #6c757d;
        }
        .form-buttons a:hover {
            background-color: #5a6268;
        }
        .message {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
            text-align: center;
            font-size: 14px;
        }
        .message.success {
            background-color: #d4edda;
            color: #155724;
        }
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
        }
        .password-container {
            position: relative;
        }
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #666;
        }
        .error-text {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
    </style>
    <script>
        function validateProfileForm() {
            var name = document.getElementById("name").value.trim();
            var email = document.getElementById("email").value.trim();
            var mobile = document.getElementById("mobile_number").value.trim();
            var fileInput = document.getElementById("profile_picture");
            var errors = [];

            if (name === "") {
                errors.push("Name is required.");
                document.getElementById("name-error").style.display = "block";
            } else {
                document.getElementById("name-error").style.display = "none";
            }

            if (email === "" || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                errors.push("A valid email is required.");
                document.getElementById("email-error").style.display = "block";
            } else {
                document.getElementById("email-error").style.display = "none";
            }

            if (mobile !== "" && !/^\d{10}$/.test(mobile)) {
                errors.push("Mobile number must be 10 digits.");
                document.getElementById("mobile-error").style.display = "block";
            } else {
                document.getElementById("mobile-error").style.display = "none";
            }

            if (fileInput.files.length > 0) {
                var file = fileInput.files[0];
                var validTypes = ["image/jpeg", "image/png", "image/gif"];
                if (!validTypes.includes(file.type)) {
                    errors.push("Profile picture must be JPG, PNG, or GIF.");
                    document.getElementById("file-error").style.display = "block";
                } else if (file.size > 2 * 1024 * 1024) {
                    errors.push("Profile picture must be less than 2MB.");
                    document.getElementById("file-error").style.display = "block";
                } else {
                    document.getElementById("file-error").style.display = "none";
                }
            }

            if (errors.length > 0) {
                alert(errors.join("\n"));
                return false;
            }
            return true;
        }

        function validatePasswordForm() {
            var newPassword = document.getElementById("new_password").value;
            var confirmPassword = document.getElementById("confirm_password").value;
            var errors = [];

            if (newPassword === "") {
                errors.push("New password is required.");
                document.getElementById("new-password-error").style.display = "block";
            } else if (newPassword.length < 8) {
                errors.push("Password must be at least 8 characters long.");
                document.getElementById("new-password-error").style.display = "block";
            } else {
                document.getElementById("new-password-error").style.display = "none";
            }

            if (confirmPassword === "") {
                errors.push("Confirm password is required.");
                document.getElementById("confirm-password-error").style.display = "block";
            } else if (newPassword !== confirmPassword) {
                errors.push("Passwords do not match.");
                document.getElementById("confirm-password-error").style.display = "block";
            } else {
                document.getElementById("confirm-password-error").style.display = "none";
            }

            if (errors.length > 0) {
                alert(errors.join("\n"));
                return false;
            }
            return true;
        }

        function togglePassword(fieldId, iconId) {
            var field = document.getElementById(fieldId);
            var icon = document.getElementById(iconId);
            if (field.type === "password") {
                field.type = "text";
                icon.className = "fas fa-eye-slash password-toggle";
            } else {
                field.type = "password";
                icon.className = "fas fa-eye password-toggle";
            }
        }

        function previewImage(event) {
            var preview = document.getElementById("profile-picture-preview");
            var file = event.target.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <div class="settings-container">
        <h2>Settings</h2>

        <%
            String message = (String) request.getAttribute("message");
            String alertType = (String) request.getAttribute("alertType");
            if (message != null && alertType != null) {
        %>
            <div class="message <%= alertType %>"><%= message %></div>
        <%
            }
            in.efficio.model.TeamLeader user = (in.efficio.model.TeamLeader) request.getAttribute("user");
            if (user != null) {
        %>
        <!-- Profile Update Section -->
        <div class="section">
            <h3>Update Profile</h3>
            <form action="<%= request.getContextPath() %>/TeamLeaderProfileServlet" method="post" enctype="multipart/form-data" onsubmit="return validateProfileForm()">
                <input type="hidden" name="teamLeaderId" value="<%= user.getTeamleader_id() %>">
                <input type="hidden" name="role" value="TeamLeader">

                <div style="display: flex; align-items: flex-start;">
                    <!-- Profile Picture -->
                    <div style="flex: 1; text-align: center;">
                        <div class="profile-picture-container">
                            <%
                                String profilePicture = user.getProfile_picture();
                                if (profilePicture != null && !profilePicture.isEmpty()) {
                            %>
                                <img src="<%= request.getContextPath() %>/<%= profilePicture %>" id="profile-picture-preview" class="profile-picture" alt="Profile Picture">
                            <%
                                } else {
                            %>
                                <img src="<%= request.getContextPath() %>/views/assets/images/default-profile.png" id="profile-picture-preview" class="profile-picture" alt="Default Profile Picture">
                            <%
                                }
                            %>
                        </div>
                        <div class="form-group">
                            <label class="custom-file-upload">
                                Choose Picture
                                <input type="file" id="profile_picture" name="profile_picture" accept="image/jpeg,image/png,image/gif" onchange="previewImage(event)">
                            </label>
                            <div id="file-error" class="error-text">Invalid file type or size.</div>
                        </div>
                    </div>

                    <!-- Profile Details -->
                    <div style="flex: 2; padding-left: 20px;">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" value="<%= user.getName() != null ? user.getName() : "" %>" required>
                            <div id="name-error" class="error-text">Name is required.</div>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required>
                            <div id="email-error" class="error-text">A valid email is required.</div>
                        </div>
                        <div class="form-group">
                            <label for="mobile_number">Mobile Number</label>
                            <input type="tel" id="mobile_number" name="mobile_number" value="<%= user.getMobile_number() != null ? user.getMobile_number() : "" %>">
                            <div id="mobile-error" class="error-text">Mobile number must be 10 digits.</div>
                        </div>
                        <div class="form-group">
                            <label for="dob">Date of Birth</label>
                            <input type="date" id="dob" name="dob" value="<%= user.getDob() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(user.getDob()) : "" %>">
                        </div>
                        <div class="form-group">
                            <label for="skills">Skills</label>
                            <textarea id="skills" name="skills" rows="3"><%= user.getSkills() != null ? user.getSkills() : "" %></textarea>
                        </div>
                        <div class="form-group">
                            <label for="bio">Bio</label>
                            <textarea id="bio" name="bio" rows="4"><%= user.getBio() != null ? user.getBio() : "" %></textarea>
                        </div>
                        <div class="form-group">
                            <label for="address">Address</label>
                            <textarea id="address" name="address" rows="3"><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                        </div>
                    </div>
                </div>

                <div class="form-buttons">
                    <input type="submit" value="Update Profile">
                    <a href="<%= request.getContextPath() %>/TeamLeaderDashboardServlet?contentType=welcome">Back to Dashboard</a>
                </div>
            </form>
        </div>

        <!-- Change Password Section -->
        <div class="section">
            <h3>Change Password</h3>
            <form action="<%= request.getContextPath() %>/TeamLeaderProfileServlet" method="post" onsubmit="return validatePasswordForm()">
                <input type="hidden" name="teamLeaderId" value="<%= user.getTeamleader_id() %>">
                <input type="hidden" name="role" value="TeamLeader">
                <input type="hidden" name="action" value="changePassword">

                <div class="form-group">
                    <label for="new_password">New Password</label>
                    <div class="password-container">
                        <input type="password" id="new_password" name="new_password" required>
                        <i id="new-password-toggle" class="fas fa-eye password-toggle" onclick="togglePassword('new_password', 'new-password-toggle')"></i>
                    </div>
                    <div id="new-password-error" class="error-text">Password must be at least 8 characters long.</div>
                </div>
                <div class="form-group">
                    <label for="confirm_password">Confirm Password</label>
                    <div class="password-container">
                        <input type="password" id="confirm_password" name="confirm_password" required>
                        <i id="confirm-password-toggle" class="fas fa-eye password-toggle" onclick="togglePassword('confirm_password', 'confirm-password-toggle')"></i>
                    </div>
                    <div id="confirm-password-error" class="error-text">Passwords do not match.</div>
                </div>

                <div class="form-buttons">
                    <input type="submit" value="Change Password">
                    <a href="<%= request.getContextPath() %>/TeamLeaderDashboardServlet?contentType=welcome">Back to Dashboard</a>
                </div>
            </form>
        </div>
        <%
            } else {
        %>
        <div class="message error">Error: User data not found</div>
        <%
            }
        %>
    </div>
</body>
</html>