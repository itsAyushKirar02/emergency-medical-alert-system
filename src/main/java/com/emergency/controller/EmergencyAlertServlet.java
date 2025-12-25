package com.emergency.controller;

import com.emergency.dao.AlertDAO;
import com.emergency.dao.HospitalDAO;
import com.emergency.dao.UserDAO;
import com.emergency.model.EmergencyContact;
import com.emergency.model.Hospital;
import com.emergency.model.User;
import com.emergency.util.NotificationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EmergencyAlertServlet")
public class EmergencyAlertServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"You are not logged in.\"}");
            return;
        }

        String latParam = request.getParameter("lat");
        String lngParam = request.getParameter("lng");
        if (latParam == null || latParam.isEmpty() || lngParam == null || lngParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Location data is missing.\"}");
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
            double lat = Double.parseDouble(latParam);
            double lng = Double.parseDouble(lngParam);

            HospitalDAO hospitalDAO = new HospitalDAO();
            List<Hospital> nearbyHospitals = hospitalDAO.findNearbyHospitals(lat, lng, 10);

            new AlertDAO().createAlert(userId, lat, lng);
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);
            List<EmergencyContact> contacts = userDAO.getEmergencyContacts(userId);

            if (user == null) {
                throw new Exception("User not found.");
            }
            
            // --- THIS IS THE FINAL CORRECTED LINE ---
            String mapLink = "https://www.google.com/maps?q=" + lat + "," + lng;
            
            String emailSubject = "Emergency Alert: " + user.getFullName();
            String emailBody = "An emergency has been reported by: " + user.getFullName() +
                             "\n\nLive Location: " + mapLink +
                             "\n\nThe user's medical document is attached.";

            NotificationService notificationService = new NotificationService();

            String smsBody = "EMERGENCY ALERT from " + user.getFullName() + "! Help needed at: " + mapLink;
            for (EmergencyContact contact : contacts) {
                notificationService.sendSms(contact.getPhone(), smsBody);
                notificationService.sendEmailWithAttachment(
                        contact.getEmail(), 
                        emailSubject, 
                        emailBody, 
                        user.getMedicalDocPath(),
                        user.getEmail(),                 // Pass the user's email as the sender
                        user.getGoogleRefreshToken()       // Pass the user's saved Refresh Token
                    );
            }

            List<String> notifiedHospitalNames = new ArrayList<>();
            for (Hospital hospital : nearbyHospitals) {
            	notificationService.sendEmailWithAttachment(
                        hospital.getContactEmail(), 
                        emailSubject, 
                        emailBody, 
                        user.getMedicalDocPath(),
                        user.getEmail(),                 // Pass the user's email as the sender
                        user.getGoogleRefreshToken()       // Pass the user's saved Refresh Token
                    );
                notifiedHospitalNames.add(hospital.getName());
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("status", "success");
            jsonResponse.put("contactsNotified", contacts.size());
            jsonResponse.put("hospitalsNotified", new JSONArray(notifiedHospitalNames));
            response.getWriter().write(jsonResponse.toString());

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Failed to process alert.\"}");
            e.printStackTrace();
        }
    }

}