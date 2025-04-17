package in.efficio.controllers;

import in.efficio.dao.EmployeeDAO;
import in.efficio.model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/Employees")
public class EmployeeServlet extends HttpServlet {
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        String idParam = request.getParameter("id");
        String from = request.getParameter("from"); // Track origin
        request.setAttribute("contentType", "view-employees");

        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                Optional<Employee> empOptional = employeeDAO.getEmployeeById(id);
                if (empOptional.isPresent()) {
                    request.setAttribute("employee", empOptional.get());
                    request.setAttribute("from", from); // Pass origin to JSP
                    request.getRequestDispatcher("views/dashboards/admin/admin-dashboard.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Employee not found.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid Employee ID.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } else {
            List<Employee> employees = employeeDAO.getAllEmployees();
            int employeeCount = employeeDAO.getEmployeeCount();
            request.setAttribute("employees", employees);
            request.setAttribute("employeeCount", employeeCount);
            request.getRequestDispatcher("views/dashboards/admin/admin-dashboard.jsp").forward(request, response);
        }
    }
}
