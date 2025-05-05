<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Efficio | Reset Password</title>
    <link rel="stylesheet" href="views/assets/css/forms/logins/style.css">
    <link rel="icon" href="https://img.icons8.com/?size=48&id=108652&format=png&color=FFFFFF" type="image/png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <a href="index.jsp" class="back-btn">Back to Home</a>
    <div class="login-container">
        <form action="ResetPasswordServlet" method="POST" onsubmit="return validateForm()">
            <h2>Reset Password<br><span>Enter the code and new password</span></h2>
            
            <input type="hidden" name="email" value="<%= request.getParameter("email") %>">
            <input type="hidden" name="role" value="<%= request.getParameter("role") %>">

            <div class="input-group">
                <label for="code">Reset Code</label>
                <input type="text" name="code" id="code" required placeholder="Enter the code">
            </div>

            <div class="input-group password-group">
                <label for="password">New Password</label>
                <input type="password" name="password" id="password" required placeholder="Enter new password">
                <span id="toggleIcon" class="toggle-password fa fa-eye" onclick="togglePassword()"></span>
            </div>

            <div class="input-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" name="confirmPassword" id="confirmPassword" required placeholder="Confirm new password">
            </div>

            <%-- Server-side Message Display --%>
            <div class="message">
                <%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>
            </div>

            <input type="submit" value="Reset Password">
            
            <div class="register-link">
                Back to <a href="LoginServlet">Login</a>
            </div>
        </form>
    </div>
    
    <script src="views/assets/js/forms/logins/script.js"></script>
    <script>
        function validateForm() {
            let password = document.getElementById("password"). _

System: value;
            let confirmPassword = document.getElementById("confirmPassword").value;
            if (password !== confirmPassword) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>