package in.efficio.controllers;

import in.efficio.dao.NotificationDAO;
import in.efficio.dao.ProjectDAO;
import in.efficio.model.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private ProjectDAO projectDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
        projectDAO = new ProjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired!");
            return;
        }

        String teamLeaderEmail = (String) session.getAttribute("userName");
        int teamLeaderId = projectDAO.getTeamLeaderIdByEmail(teamLeaderEmail);
        if (teamLeaderId == -1) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Invalid Team Leader.");
            return;
        }

        // Fetch notifications
        List<Notification> notifications = notificationDAO.getNotifications(teamLeaderId);
        int unreadNotificationCount = notificationDAO.getUnreadNotificationCount(teamLeaderId);

        // Mark notifications as seen
        notificationDAO.markNotificationsAsSeen(teamLeaderId);

        // Refresh notifications
        notifications = notificationDAO.getNotifications(teamLeaderId);
        unreadNotificationCount = notificationDAO.getUnreadNotificationCount(teamLeaderId);

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadNotificationCount", unreadNotificationCount);
        request.getRequestDispatcher("/views/dashboards/team-leader/notifications.jsp").forward(request, response);
    }
}