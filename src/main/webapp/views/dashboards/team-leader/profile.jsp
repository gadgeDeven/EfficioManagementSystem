<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.Employee"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Team Leader Profile | Efficio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/employee-dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
<div class="proj-details">
    <h1><i class="fas fa-user"></i> My Profile</h1>

    <%
        Employee user = (Employee) request.getAttribute("user");
        if (user == null) {
    %>
        <p class="proj-no-data"><i class="fas fa-exclamation-circle"></i> Profile not found.</p>
    <% } else { %>
        <div class="proj-details-grid">
            <p><strong><i class="fas fa-id-badge"></i> Team Leader ID:</strong> <%= user.getEmployee_id() != 0 ? user.getEmployee_id() : "N/A" %></p>
            <p><strong><i class="fas fa-user"></i> Name:</strong> <%= user.getName() != null ? user.getName() : "N/A" %></p>
            <p><strong><i class="fas fa-envelope"></i> Email:</strong> <%= user.getEmail() != null ? user.getEmail() : "N/A" %></p>
            <p><strong><i class="fas fa-phone"></i> Mobile Number:</strong> <%= user.getMobile_number() != null ? user.getMobile_number() : "N/A" %></p>
        </div>
        <h3><i class="fas fa-edit"></i> Update Profile</h3>
        <form action="${pageContext.request.contextPath}/TeamLeaderProfileServlet" method="post" class="proj-edit">
            <div class="proj-form-group">
                <label><i class="fas fa-user"></i> Name:</label>
                <input type="text" name="name" value="<%= user.getName() != null ? user.getName() : "" %>" required>
            </div>
            <div class="proj-form-group">
                <label><i class="fas fa-phone"></i> Mobile Number:</label>
                <input type="text" name="mobileNumber" value="<%= user.getMobile_number() != null ? user.getMobile_number() : "" %>" pattern="[0-9]{10}" title="Enter a 10-digit mobile number">
            </div>
            <div class="proj-form-group">
                <label><i class="fas fa-lock"></i> New Password (leave blank to keep current):</label>
                <input type="password" name="newPassword" placeholder="Enter new password">
            </div>
            <div class="proj-form-actions">
                <button type="submit" class="proj-btn"><i class="fas fa-save"></i> Save Changes</button>
            </div>
        </form>
    <% } %>
</div>
</body>
</html>