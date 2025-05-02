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
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            font-family: Arial, sans-serif;
            transition: all 0.3s ease;
        }
        .dark-mode .settings-container {
            background-color: #2c2c2c;
            color: #e0e0e0;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
        }
        .settings-container h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 20px;
        }
        .dark-mode .settings-container h2 {
            color: #e0e0e0;
        }
        .section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            transition: transform 0.2s;
        }
        .dark-mode .section {
            background-color: #3a3a3a;
        }
        .section:hover {
            transform: translateY(-5px);
        }
        .section h3 {
            color: #007bff;
            margin-bottom: 15px;
        }
        .dark-mode .section h3 {
            color: #1e90ff;
        }
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        .form-group label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        .dark-mode .form-group label {
            color: #e0e0e0;
        }
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .dark-mode .form-group input, .dark-mode .form-group textarea {
            background-color: #4a4a4a;
            border-color: #666;
            color: #e0e0e0;
        }
        .form-group input:focus, .form-group textarea:focus {
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
            outline: none;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
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
            border: 3px solid #007bff;
            transition: border-color 0.3s;
        }
        .dark-mode .profile-picture {
            border-color: #1e90ff;
        }
        .dropzone {
            border: 2px dashed #ced4da;
            border-radius: 5px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: border-color 0.3s;
        }
        .dropzone.dragover {
            border-color: #007bff;
            background-color: rgba(0, 123, 255, 0.1);
        }
        .dark-mode .dropzone {
            border-color: #666;
        }
        .dark-mode .dropzone.dragover {
            border-color: #1e90ff;
            background-color: rgba(30, 144, 255, 0.1);
        }
        .custom-file-upload {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin-top: 10px;
        }
        .custom-file-upload:hover {
            background-color: #0056b3;
        }
        .dark-mode .custom-file-upload {
            background-color: #1e90ff;
        }
        .dark-mode .custom-file-upload:hover {
            background-color: #006cdc;
        }
        .form-group input[type="file"] {
            display: none;
        }
        .form-buttons {
            text-align: center;
            margin-top: 20px;
        }
        .form-buttons input[type="submit"], .form-buttons a {
            padding: 12px 25px;
            margin: 0 10px;
            text-decoration: none;
            color: #fff;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s;
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
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
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
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #666;
        }
        .dark-mode .password-toggle {
            color: #bbb;
        }
        .error-text {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        .password-strength {
            height: 5px;
            margin-top: 5px;
            border-radius: 3px;
            transition: width 0.3s, background-color 0.3s;
        }
        .password-strength.weak {
            width: 33%;
            background-color: #dc3545;
        }
        .password-strength.medium {
            width: 66%;
            background-color: #ffc107;
        }
        .password-strength.strong {
            width: 100%;
            background-color: #28a745;
        }
        .theme-toggle {
            text-align: right;
            margin-bottom: 20px;
        }
        .theme-toggle button {
            padding: 8px 15px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .theme-toggle button:hover {
            background-color: #0056b3;
        }
        .dark-mode .theme-toggle button {
            background-color: #1e90ff;
        }
        .dark-mode .theme-toggle button:hover {
            background-color: #006cdc;
        }
        @media (max-width: 768px) {
            .settings-container {
                margin: 10px;
                padding: 15px;
            }
            .section {
                padding: 15px;
            }
            .form-group input, .form-group textarea {
                padding: 10px;
            }
            .profile-picture {
                width: 100px;
                height: 100px;
            }
        }
    </style>
    <script>
        function validateProfileForm() {
            const name = document.getElementById("name").value.trim();
            const email = document.getElementById("email").value.trim();
            const mobile = document.getElementById("mobile_number").value.trim();
            const fileInput = document.getElementById("profile_picture");
            const errors = [];

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
                const file = fileInput.files[0];
                const validTypes = ["image/jpeg", "image/png", "image/gif"];
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
            const newPassword = document.getElementById("new_password").value;
            const confirmPassword = document.getElementById("confirm_password").value;
            const errors = [];

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
            const field = document.getElementById(fieldId);
            const icon = document.getElementById(iconId);
            if (field.type === "password") {
                field.type = "text";
                icon.className = "fas fa-eye-slash password-toggle";
            } else {
                field.type = "password";
                icon.className = "fas fa-eye password-toggle";
            }
        }

        function previewImage(event) {
            const preview = document.getElementById("profile-picture-preview");
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        }

        function handleDrop(event) {
            event.preventDefault();
            const dropzone = event.target;
            dropzone.classList.remove("dragover");
            const fileInput = document.getElementById("profile_picture");
            fileInput.files = event.dataTransfer.files;
            previewImage({ target: fileInput });
        }

        function handleDragOver(event) {
            event.preventDefault();
            event.target.classList.add("dragover");
        }

        function handleDragLeave(event) {
            event.target.classList.remove("dragover");
        }

        function updatePasswordStrength() {
            const password = document.getElementById("new_password").value;
            const strengthBar = document.getElementById("password-strength");
            let strength = 0;
            if (password.length >= 8) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;

            strengthBar.className = "password-strength";
            if (password.length === 0) {
                strengthBar.style.width = "0";
            } else if (strength <= 2) {
                strengthBar.classList.add("weak");
            } else if (strength === 3) {
                strengthBar.classList.add("medium");
            } else {
                strengthBar.classList.add("strong");
            }
        }

        function toggleTheme() {
            document.body.classList.toggle("dark-mode");
            const button = document.getElementById("theme-toggle");
            button.textContent = document.body.classList.contains("dark-mode") ? "Light Mode" : "Dark Mode";
        }

        document.addEventListener("DOMContentLoaded", function() {
            const nameInput = document.getElementById("name");
            const emailInput = document.getElementById("email");
            const mobileInput = document.getElementById("mobile_number");
            const passwordInput = document.getElementById("new_password");

            nameInput.addEventListener("input", function() {
                document.getElementById("name-error").style.display = nameInput.value.trim() === "" ? "block" : "none";
            });

            emailInput.addEventListener("input", function() {
                const email = emailInput.value.trim();
                document.getElementById("email-error").style.display = (email === "" || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) ? "block" : "none";
            });

            mobileInput.addEventListener("input", function() {
                const mobile = mobileInput.value.trim();
                document.getElementById("mobile-error").style.display = (mobile !== "" && !/^\d{10}$/.test(mobile)) ? "block" : "none";
            });

            passwordInput.addEventListener("input", updatePasswordStrength);

            const dropzone = document.getElementById("dropzone");
            dropzone.addEventListener("dragover", handleDragOver);
            dropzone.addEventListener("dragleave", handleDragLeave);
            dropzone.addEventListener("drop", handleDrop);
        });
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <div class="settings-container">
        <div class="theme-toggle">
            <button id="theme-toggle" onclick="toggleTheme()">Dark Mode</button>
        </div>
        <h2>Settings</h2>

        <%
            String message = (String) request.getAttribute("message");
            String alertType = (String) request.getAttribute("alertType");
            if (message != null && alertType != null) {
        %>
            <div class="message <%= alertType %>"><%= message %></div>
        <%
            }
            in.efficio.model.Employee user = (in.efficio.model.Employee) request.getAttribute("user");
            if (user != null) {
        %>
        <!-- Profile Update Section -->
        <div class="section">
            <h3>Update Profile</h3>
            <form action="<%= request.getContextPath() %>/EmployeeProfileServlet" method="post" enctype="multipart/form-data" onsubmit="return validateProfileForm()">
                <input type="hidden" name="employeeId" value="<%= user.getEmployee_id() %>">
                <input type="hidden" name="role" value="Employee">

                <div style="display: flex; align-items: flex-start; gap: 20px;">
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
                            <div id="dropzone" class="dropzone">
                                Drag & Drop Image Here or
                                <label class="custom-file-upload">
                                    Choose Picture
                                    <input type="file" id="profile_picture" name="profile_picture" accept="image/jpeg,image/png,image/gif" onchange="previewImage(event)">
                                </label>
                            </div>
                            <div id="file-error" class="error-text">Invalid file type or size.</div>
                        </div>
                    </div>

                    <!-- Profile Details -->
                    <div style="flex: 2;">
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
                    <a href="<%= request.getContextPath() %>/EmployeeDashboardServlet?contentType=welcome">Back to Dashboard</a>
                </div>
            </form>
        </div>

        <!-- Change Password Section -->
        <div class="section">
            <h3>Change Password</h3>
            <form action="<%= request.getContextPath() %>/EmployeeProfileServlet" method="post" onsubmit="return validatePasswordForm()">
                <input type="hidden" name="employeeId" value="<%= user.getEmployee_id() %>">
                <input type="hidden" name="role" value="Employee">
                <input type="hidden" name="action" value="changePassword">

                <div class="form-group">
                    <label for="new_password">New Password</label>
                    <div class="password-container">
                        <input type="password" id="new_password" name="new_password" required>
                        <i id="new-password-toggle" class="fas fa-eye password-toggle" onclick="togglePassword('new_password', 'new-password-toggle')"></i>
                    </div>
                    <div id="new-password-error" class="error-text">Password must be at least 8 characters long.</div>
                    <div id="password-strength" class="password-strength"></div>
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
                    <a href="<%= request.getContextPath() %>/EmployeeDashboardServlet?contentType=welcome">Back to Dashboard</a>
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