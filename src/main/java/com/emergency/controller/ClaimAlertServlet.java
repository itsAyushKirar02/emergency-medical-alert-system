package com.emergency.controller;

import com.emergency.dao.AlertDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ClaimAlertServlet")
public class ClaimAlertServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int alertId = Integer.parseInt(request.getParameter("alertId"));
            int hospitalId = Integer.parseInt(request.getParameter("hospitalId"));

            AlertDAO alertDAO = new AlertDAO();
            boolean success = alertDAO.claimAlert(alertId, hospitalId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            if (success) {
                response.getWriter().write("{\"status\":\"success\", \"message\":\"Alert claimed successfully.\"}");
            } else {
                response.getWriter().write("{\"status\":\"failure\", \"message\":\"Alert may have already been claimed by another hospital.\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Invalid request.\"}");
        }
    }
}