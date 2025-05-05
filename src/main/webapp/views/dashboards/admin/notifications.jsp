<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, in.efficio.model.PendingRegistration, in.efficio.dao.PendingRegistrationDAO"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/notifications.css">
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<div class="notification-content">
    <button class="close-btn" id="closeNotification"><i class="fas fa-times"></i></button>
    <table class="table-modern">
        <thead>
            <tr id="head">
                <th>ID</th>
                <th>Role</th>
                <th>Name</th>
                <th>Email</th>
                <th>Department</th>
                <th>Status</th>
                <th>Action  <button class="close-btn" id="closeNotification"><i class="fas fa-times"></i></button></th>
               
            </tr>
        </thead>
        <tbody id="notificationTable">
            <%
                PendingRegistrationDAO dao = new PendingRegistrationDAO();
                List<PendingRegistration> pendingRequests = dao.getPendingRegistrations();
                if (pendingRequests != null && !pendingRequests.isEmpty()) {
                    for (PendingRegistration req : pendingRequests) {
                        String rowClass = req.isSeen() ? "" : "unseen-row";
            %>
                <tr id="notification_<%=req.getId()%>" class="<%=rowClass%>">
                    <td><%=req.getId()%></td>
                    <td><%=req.getRole()%></td>
                    <td><%=req.getName()%></td>
                    <td><%=req.getEmail()%></td>
                    <td><%=req.getDepartment()%></td>
                    <td><%=req.getStatus()%></td>
                    <td>
                        <button class="btn-approve" onclick="handleAction('<%=req.getId()%>', '<%=req.getRole()%>', 'Approved')">Accept</button>
                        <button class="btn-reject" onclick="handleAction('<%=req.getId()%>', '<%=req.getRole()%>', 'Rejected')">Reject</button>
                    </td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr><td colspan="7">No pending requests.</td></tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>
<script src="${pageContext.request.contextPath}/views/assets/js/admin/notifications.js"></script>