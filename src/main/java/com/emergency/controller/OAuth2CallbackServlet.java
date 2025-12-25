// In src/com/emergency/controller/OAuth2CallbackServlet.java
package com.emergency.controller;

import com.emergency.dao.UserDAO;
import com.emergency.model.User;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/oauth2callback")
public class OAuth2CallbackServlet extends HttpServlet {
    private static final String CLIENT_ID = System.getenv("GMAIL_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("GMAIL_CLIENT_SECRET");
    private static final String REDIRECT_URI = System.getenv("OAUTH_REDIRECT_URL");

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect("login.jsp?error=auth_failed");
            return;
        }

        // Exchange code for tokens
        GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
            new NetHttpTransport(), GsonFactory.getDefaultInstance(), CLIENT_ID, CLIENT_SECRET, code, REDIRECT_URI).execute();
        
        // Get user profile information from the ID token
        GoogleIdToken idToken = tokenResponse.parseIdToken();
        GoogleIdToken.Payload payload = idToken.getPayload();
        String email = payload.getEmail();
        String name = (String) payload.get("name");
        
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);  
        
        if (user != null) {
            // --- USER EXISTS: LOG THEM IN ---
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("fullName", user.getFullName());
            response.sendRedirect("dashboard.jsp");
        } else {
            // --- NEW USER: REDIRECT TO COMPLETE REGISTRATION ---
            HttpSession session = request.getSession();
            session.setAttribute("google_email", email);
            session.setAttribute("google_name", name);
            session.setAttribute("google_refresh_token", tokenResponse.getRefreshToken());
            response.sendRedirect("complete_registration.jsp");
        }
    }
}