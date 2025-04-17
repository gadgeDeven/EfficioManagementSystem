<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.Notification"%>
<div class="notification-content">
    <button class="close-btn" onclick="window.location.href='TeamLeaderDashboard?contentType=welcome'"><i class="fas fa-times"></i></button>
    <h1>Notifications</h1>
    <table class="table-modern">
        <thead>
            <tr>
                <th>Type</th>
                <th>Message</th>
            </tr>
        </thead>
        <tbody>
            <% 
                List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
                if (notifications != null && !notifications.isEmpty()) {
                    for (Notification notification : notifications) {
            %>
                <tr>
                    <td>
                        <%= notification.getType() %>
                        <% if (!notification.isSeen()) { %>
                            <span class="unread-dot"></span>
                        <% } %>
                    </td>
                    <td><%= notification.getMessage() %></td>
                </tr>
            <% 
                    }
                } else {
            %>
                <tr><td colspan="2">No new notifications.</td></tr>
            <% } %>
        </tbody>
    </table>
</div>

<style>
    .unread-dot {
        display: inline-block;
        width: 8px;
        height: 8px;
        background-color: red;
        border-radius: 50%;
        margin-left: 5px;
    }
    .table-modern {
        width: 100%;
        border-collapse: collapse;
    }
    .table-modern th, .table-modern td {
        padding: 10px;
        border: 1px solid #ddd;
        text-align: left;
    }
    .table-modern th {
        background-color: #f4f4f4;
    }
    .close-btn {
        float: right;
        background: none;
        border: none;
        font-size: 18px;
        cursor: pointer;
    }
</style>