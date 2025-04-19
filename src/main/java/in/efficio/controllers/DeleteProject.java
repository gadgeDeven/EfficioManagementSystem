package in.efficio.controllers;

import in.efficio.dao.ProjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteProject")
public class DeleteProject extends HttpServlet {
    private ProjectDAO projectDAO;

    @Override
    public void init() {
        projectDAO = new ProjectDAO();
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
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            projectDAO.deleteProject(projectId);
            session.setAttribute("message", "Project deleted successfully!");
            response.sendRedirect(request.getContextPath() + "/Projects?contentType=view-projects");
        } catch (Exception e) {
            session.setAttribute("error", "Failed to delete project: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Projects?contentType=view-projects");
        }
    }
}