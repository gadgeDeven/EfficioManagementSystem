<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Efficio | Login</title>
    <link rel="stylesheet" href="views/assets/css/forms/logins/style.css">
    <link rel="icon" href="https://img.icons8.com/?size=48&id=108652&format=png&color=FFFFFF" type="image/png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <a href="index.jsp" class="back-btn">Back to Home</a>
    <div class="login-container">
        <form action="LoginServlet" method="POST" onsubmit="return validateForm()">
            <h2>Welcome to Efficio<br><span>Login to Continue</span></h2>
            
            <div class="input-group">
                <label for="role">Select Role</label>
                <select name="role" id="role" required>
                    <option value="">-- Choose Role --</option>
                    <option value="Admin">Admin</option>
                    <option value="TeamLeader">Team Leader</option>
                    <option value="Employee">Employee</option>
                </select>
            </div>

            <div class="input-group">
                <label for="email">Email</label>
                <input type="email" name="email" id="email" required placeholder="Enter Email">
            </div>

            <div class="input-group password-group">
                <label for="password">Password</label>
                <input type="password" name="password" id="password" required placeholder="Enter Password">
                <span id="toggleIcon" class="toggle-password fa fa-eye" onclick="togglePassword()"></span>
            </div>

            <%-- Server-side Message Display --%>
            <div class="message">
                <%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>
            </div>

            <%-- Client-side Error Message --%>
            <div id="error-message" class="message"></div>

            <input type="submit" value="Login">
            
            <div class="register-link">
                Don't have an account? <a href="UserRegisterServlet">Register here</a>
            </div>
        </form>
    </div>
    
    <script src="views/assets/js/forms/logins/script.js"></script>
</body>
</html>