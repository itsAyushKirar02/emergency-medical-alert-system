package com.emergency.controller;

import com.emergency.dao.UserDAO;
import com.emergency.model.EmergencyContact;
import com.emergency.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.Scanner;

@WebServlet("/CompleteRegistrationServlet")
@MultipartConfig
public class CompleteRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "C:/emergency_uploads";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("google_email") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            String email = (String) session.getAttribute("google_email");
            String name = (String) session.getAttribute("google_name");
            String refreshToken = (String) session.getAttribute("google_refresh_token");

            Part filePart = request.getPart("medicalDoc");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = UPLOAD_DIRECTORY + File.separator + uniqueFileName;
            
            new File(UPLOAD_DIRECTORY).mkdirs();
            filePart.write(filePath);
            
            User newUser = new User();
            newUser.setFullName(name);
            newUser.setEmail(email);
            newUser.setMedicalDocPath(filePath);
            newUser.setGoogleRefreshToken(refreshToken);
            newUser.setPassword("GOOGLE_LOGGED_IN");

            UserDAO userDAO = new UserDAO();
            User createdUser = userDAO.createUserAndReturn(newUser);
            if (createdUser == null) {
                throw new ServletException("Failed to create user in the database.");
            }

            String contactName = extractFieldValue(request.getPart("contactName"));
            String contactPhone = extractFieldValue(request.getPart("contactPhone"));
            String contactEmail = extractFieldValue(request.getPart("contactEmail"));
            EmergencyContact contact = new EmergencyContact();
            contact.setName(contactName);
            contact.setPhone(contactPhone);
            contact.setEmail(contactEmail);
            userDAO.addEmergencyContact(createdUser.getUserId(), contact);

            session.setAttribute("userId", createdUser.getUserId());
            session.setAttribute("fullName", createdUser.getFullName());
            session.removeAttribute("google_email");
            session.removeAttribute("google_name");
            session.removeAttribute("google_refresh_token");
            response.sendRedirect("dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=registration_failed");
        }
    }
    
    private String extractFieldValue(Part part) throws IOException {
        if (part == null) return null;
        try (InputStream inputStream = part.getInputStream();
             Scanner scanner = new Scanner(inputStream, "UTF-8").useDelimiter("\\A")) {
            return scanner.hasNext() ? scanner.next() : "";
        }
    }
}