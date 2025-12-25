package com.emergency.controller;

import com.emergency.dao.UserDAO;
import com.emergency.model.EmergencyContact;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AddContactServlet")
public class AddContactServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String name = request.getParameter("contactName");
        String phone = request.getParameter("contactPhone");
        String email = request.getParameter("contactEmail");

        EmergencyContact contact = new EmergencyContact();
        contact.setName(name);
        contact.setPhone(phone);
        contact.setEmail(email);

        UserDAO userDAO = new UserDAO();
        userDAO.addEmergencyContact(userId, contact);

        response.sendRedirect("ProfileServlet");
    }
}