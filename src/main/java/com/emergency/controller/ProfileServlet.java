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
import java.util.List;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (int) session.getAttribute("userId");
        UserDAO userDAO = new UserDAO();
        List<EmergencyContact> contacts = userDAO.getEmergencyContacts(userId);
        
        request.setAttribute("contacts", contacts);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}