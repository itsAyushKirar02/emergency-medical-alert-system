package com.emergency.controller;

import com.emergency.dao.AlertDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/GetActiveAlertsServlet")
public class GetActiveAlertsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AlertDAO alertDAO = new AlertDAO();
        
        // MODIFIED: Call the new method to get ONLY unclaimed alerts
        String alertsJson = alertDAO.getUnclaimedAlertsAsJson();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(alertsJson);
    }
}