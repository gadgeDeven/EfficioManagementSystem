package in.efficio.controllers;

import java.io.IOException;

import in.efficio.dao.PendingRegistrationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/MarkAsSeenServlet")
public class MarkAsSeenServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException
            , IOException {
        PendingRegistrationDAO dao = new PendingRegistrationDAO();
        dao.markAsSeen();
        response.setStatus(HttpServletResponse.SC_OK);
    }
}