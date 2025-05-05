<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Efficio | Forgot Password</title>
    <link rel="stylesheet" href="views/assets/css/forms/logins/style.css">
    <link rel="icon" href="https://img.icons8.com/?size=48&id=108652&format=png&color=FFFFFF" type="image/png">
</head>
<body>
    <a href="index.jsp" class="back-btn">Back to Home</a>
    <div class="login-container">
        <form action="ForgotPasswordServlet" method="POST">
            <h2>Forgot Password<br><span>Enter your details to reset</span></h2>
            
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

            <%-- Server-side Message Display --%>
            <div class="message">
                <%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>
            </div>

            <input type="submit" value="Send Reset Code">
            
            <div class="register-link">
                Back to <a href="LoginServlet">Login</a>
            </div>
        </form>
    </div>
</body>
</html>