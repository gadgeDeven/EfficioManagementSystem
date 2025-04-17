package in.efficio.controllers;

import in.efficio.dao.EmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteEmployee")
public class DeleteEmployee extends HttpServlet {
    private EmployeeDAO employeeDAO;

    @Override
    public void init() {
        employeeDAO = new EmployeeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            boolean deleted = employeeDAO.deleteEmployee(id);

            if (deleted) {
                response.sendRedirect("Employees?msg=Employee+deleted+successfully");
            } else {
                response.sendRedirect("Employees?error=Failed+to+delete+employee");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("Employees?error=Invalid+Employee+ID");
        }
    }
}
