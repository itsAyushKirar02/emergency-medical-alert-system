package com.emergency.controller;

import com.emergency.dao.UserDAO;
import com.emergency.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/DownloadDocumentServlet") // This annotation is crucial
public class DownloadDocumentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);

            if (user == null || user.getMedicalDocPath() == null || user.getMedicalDocPath().isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Medical document not found.");
                return;
            }

            File document = new File(user.getMedicalDocPath());
            if (!document.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File does not exist on server.");
                return;
            }

            response.setContentType("application/octet-stream");
            response.setContentLengthLong(document.length());
            response.setHeader("Content-Disposition", "attachment; filename=\"" + document.getName() + "\"");

            try (FileInputStream in = new FileInputStream(document);
                 OutputStream out = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID format.");
        }
    }
}