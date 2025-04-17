<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.Department" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Efficio | User Registration</title>
    <link rel="stylesheet" href="views/assets/css/forms/user-registration/style.css">
     <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/views/assets/images/favicon.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <a href="index.jsp" class="back-btn">Back to Home</a>
    <div class="register-container">
        <form action="UserRegisterServlet" method="post" onsubmit="return validateForm()">
            <h2>User Registration<br><span>Create Your Account</span></h2>

            <%-- Server-side Messages --%>
            <% String message = (String) request.getAttribute("message"); %>
            <% if (message != null) { %>
                <div class="message success-message"><%= message %></div>
            <% } %>
            <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
            <% if (errorMessage != null) { %>
                <div class="message error-message"><%= errorMessage %></div>
            <% } %> 

            <div class="input-group">
                <label for="role">Register As</label>
                <select name="role" id="role" required>
                    <option value="">-- Select Role --</option>
                    <option value="Employee">Employee</option>
                    <option value="TeamLeader">Team Leader</option>
                </select>
                <span class="error-message"></span>
            </div>

            <div class="input-group">
                <label for="name">Name</label>
                <input type="text" name="name" id="name" required placeholder="Enter your name">
                <span class="error-message"></span>
            </div>

            <div class="input-group">
                <label for="email">Email</label>
                <input type="email" name="email" id="email" required placeholder="Enter your email address">
                <span class="error-message"></span>
            </div>

            <div class="input-group password-group">
                <label for="password">Password</label>
                <input type="password" name="password" id="password" required placeholder="Create a password">
                <span id="toggleIcon" class="toggle-password fa fa-eye" onclick="togglePassword()"></span>
                <span class="error-message"></span>
            </div>

            <div class="input-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" name="confirmPassword" id="confirmPassword" required placeholder="Re-enter your password">
                <span class="error-message"></span>
            </div>

            <div class="input-group">
                <label for="dob">Date of Birth</label>
                <input type="date" name="dob" id="dob" required max="<%= java.time.LocalDate.now() %>">
                <span class="error-message"></span>
            </div>

            <div class="input-group">
                <label for="skills">Skills</label>
                <textarea name="skills" id="skills" rows="3" placeholder="E.g., Java, SQL, Spring Boot"></textarea>
            </div>

            <div class="input-group">
                <label for="department">Department</label>
                <select name="department" id="department" required>
                    <option value="">-- Select Department --</option>
                    <% 
                    List<Department> deptList = (List<Department>) request.getAttribute("departmentList");
                    if (deptList != null) {
                        for (Department dept : deptList) { %>
                            <option value="<%= dept.getDepartment_id() %>"><%= dept.getDepartment_name() %></option>
                    <% }
                    } %>
                </select>
            </div>

            <input type="submit" value="Register">
            
            <div class="login-link">
                Already have an account? <a href="LoginServlet">Login here</a>
            </div>
        </form>
    </div>

    <script src="views/assets/js/forms/user-registration/script.js"></script>
</body>
</html>