<!DOCTYPE html>
<html>
<head>
    <title>Employee Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #fff7f0;
            margin: 0;
            padding: 0;
        }
        .dashboard {
            width: 80%;
            margin: 50px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        h1 { color: #333; }
        p { color: #555; }
        
        .logout-btn {
    padding: 10px 15px;
    background: #e74c3c;
    color: white;
    text-decoration: none;
    border-radius: 5px;
    font-size: 16px;
    transition: 0.3s;
    border: none;
    cursor: pointer;
}

.logout-btn:hover {
    background: #c0392b;
}
    </style>
</head>
<body>
    <div class="dashboard">
        <h1>Welcome Employee!</h1>
        <p>Check your assigned tasks, update progress, and manage profile.</p>
        <ul>
            <li>View Assigned Tasks</li>
            <li>Update Task Status</li>
            <li>View Deadlines</li>
            <li>Submit Feedback</li>
        </ul>
    </div>
    
     <%
    if (session.getAttribute("userName") == null) {
        response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
        return; // Prevent further execution
    }
%>
    
   <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn logout-btn">Logout</a>
</body>
</html>