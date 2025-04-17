package in.efficio.controllers;

import in.efficio.dao.PendingRegistrationDAO;
import in.efficio.model.PendingRegistration;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;

@WebServlet("/PendingRequestsServlet")
public class PendingRequestsServlet extends HttpServlet {
    private PendingRegistrationDAO pendingRegistrationDAO;

    @Override
    public void init() {
        pendingRegistrationDAO = new PendingRegistrationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        // Fetch pending requests
        List<PendingRegistration> pendingRequests = pendingRegistrationDAO.getPendingRegistrations();

        // Sort in ascending order by ID
        pendingRequests.sort(Comparator.comparing(PendingRegistration::getId));

        // Set attributes
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("notificationCount", pendingRequests.size()); // Total pending count

        request.getRequestDispatcher("/views/dashboards/admin/notifications.jsp").forward(request, response);
    }
}