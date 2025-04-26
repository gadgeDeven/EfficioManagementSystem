package in.efficio.controllers;

import in.efficio.dao.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteTask")
public class DeleteTaskServlet extends HttpServlet {
    private TaskDAO taskDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String contentType = request.getParameter("contentType");
            String taskFilter = request.getParameter("taskFilter");
            taskDAO.deleteTask(taskId);
            session.setAttribute("successMessage", "Task deleted successfully!");
            response.sendRedirect(request.getContextPath() + "/TeamLeaderTaskServlet?contentType=" + contentType + "&taskFilter=" + taskFilter);
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Failed to delete task: " + e.getMessage());
            String contentType = request.getParameter("contentType");
            String taskFilter = request.getParameter("taskFilter");
            response.sendRedirect(request.getContextPath() + "/TeamLeaderTaskServlet?contentType=" + contentType + "&taskFilter=" + taskFilter);
        }
    }
}