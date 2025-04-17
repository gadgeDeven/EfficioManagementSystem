
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page language="java" %>
<%
    String messageType = (String) request.getAttribute("messageType"); // Success, Pending, Rejected
    String messageTitle = (String) request.getAttribute("messageTitle");
    String messageContent = (String) request.getAttribute("messageContent");
    String redirectUrl = (String) request.getAttribute("redirectUrl");

    // Default values
    String bgColor = "#d4edda"; // Green for success
    String textColor = "#155724";
    String icon = "😊"; // Happy face for success

    // Adjust styles based on message type
    if ("Pending".equalsIgnoreCase(messageType)) {
        bgColor = "#fff3cd"; // Yellow for pending
        textColor = "#856404";
        icon = "😐"; // Neutral face for pending
    } else if ("Rejected".equalsIgnoreCase(messageType)) {
        bgColor = "#f8d7da"; // Red for rejected
        textColor = "#721c24";
        icon = "☹️"; // Angry face for rejected
    }
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Message</title>
    <style>
        body {
            background-color: #f0f2f5;  /* Soft light gray background */
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
        }
        .message-box {
            width: 400px;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            background-color: #ffffff;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.8s ease;
        }
        .message-box h2 {
            color: #28a745;
            margin-bottom: 10px;
            animation: slideInDown 0.8s ease;
            font-size: 24px;
        }
        .message-box p {
            margin: 15px 0;
            color: #444;
            font-size: 16px;
            animation: slideInUp 0.8s ease;
        }
        .btn {
            display: inline-block;
            padding: 12px 25px;
            font-size: 15px;
            color: #ffffff;
            background-color: #007bff;  /* Updated Button Color */
            border: none;
            border-radius: 30px;
            text-decoration: none;
            transition: background-color 0.3s ease;
            margin-top: 15px;
        }
        .btn:hover {
            background-color: #0056b3;  /* Darker Blue on Hover */
        }
        .success-icon {
            width: 75px;
            height: 75px;
            border-radius: 50%;
            border: 4px solid #28a745;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px auto;
            position: relative;
            animation: popIn 0.8s ease;
        }
        .success-icon::before {
            content: "✔️";
            font-size: 36px;
            color: #28a745;
        }
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
        @keyframes slideInDown {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        @keyframes slideInUp {
            from { transform: translateY(20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        @keyframes popIn {
            from { transform: scale(0); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="message-box">
        <h2><%= icon %> <%= messageTitle %></h2>
        <p><%= messageContent %></p>
        <a href="<%= redirectUrl %>" class="btn">Continue</a>
    </div>
</body>
</html>
