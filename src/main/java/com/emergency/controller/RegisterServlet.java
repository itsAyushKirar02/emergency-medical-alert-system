package com.emergency.controller;

import com.emergency.dao.UserDAO;
import com.emergency.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.Scanner;

@WebServlet("/RegisterServlet")
@MultipartConfig
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "C:/emergency_uploads";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = extractFieldValue(request.getPart("fullName"));
        String email = extractFieldValue(request.getPart("email"));
        String password = extractFieldValue(request.getPart("password"));

        // Handle file upload
        Part filePart = request.getPart("medicalDoc");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
        String filePath = UPLOAD_DIRECTORY + File.separator + uniqueFileName;
        
        File uploadDir = new File(UPLOAD_DIRECTORY);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        filePart.write(filePath);
        
        // Create User object
        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPassword(password); // This will be hashed in the DAO
        newUser.setMedicalDocPath(filePath);

        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.registerUserWithPassword(newUser);

        if (success) {
            response.sendRedirect("login.jsp?success=1");
        } else {
            response.sendRedirect("register.jsp?error=1"); // e.g., email already exists
        }
    }

    /**
     * Helper method to correctly read the value from a text field in a multipart form.
     * @param part The Part representing the form field.
     * @return The String value of the form field.
     * @throws IOException
     */
    private String extractFieldValue(Part part) throws IOException {
        if (part == null) {
            return null;
        }
        // The try-with-resources statement ensures the stream is closed automatically.
        try (InputStream inputStream = part.getInputStream();
             Scanner scanner = new Scanner(inputStream, "UTF-8").useDelimiter("\\A")) {
            return scanner.hasNext() ? scanner.next() : "";
        }
    }
}