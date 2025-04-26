<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifications</title>
    <style>
       
        .notification-container {
            max-width: 800px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        h1 {
            font-size: 24px;
            color: #2c3e50;
            text-align: center;
            margin-bottom: 20px;
        }
        .table-modern {
            width: 100%;
            border-collapse: collapse;
        }
        .table-modern th, .table-modern td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        .table-modern th {
            background-color: #2c3e50;
            color: #ffffff;
            font-weight: 600;
        }
        .unseen-row {
            background-color: #e6f3ff;
            font-weight: bold;
        }
        .unread-dot {
            display: inline-block;
            width: 8px;
            height: 8px;
            background-color: #e74c3c;
            border-radius: 50%;
            margin-left: 5px;
        }
        .notification-link {
            color: #2980b9;
            text-decoration: none;
        }
        .close-btn {
            display: block;
            margin: 20px auto 0;
            padding: 10px 20px;
            background-color: #7f8c8d;
            color: #ffffff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="notification-container">
        <h1>Notifications</h1>
        <table class="table-modern">
            <thead>
                <tr>
                    <th>Type</th>
                    <th>Message</th>
                    <th>Time</th>
                </tr>
            </thead>
            
        </table>
        <button class="close-btn" onclick="window.location.href='<%= request.getContextPath() %>/TeamLeaderDashboard?contentType=welcome'">Close</button>
    </div>
</body>
</html>