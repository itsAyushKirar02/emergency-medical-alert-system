package com.emergency.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeRequestUrl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/GoogleSignInServlet")
public class GoogleSignInServlet extends HttpServlet {
    private static final String CLIENT_ID = System.getenv("GMAIL_CLIENT_ID");
    private static final String REDIRECT_URI = System.getenv("OAUTH_REDIRECT_URL");
    
    // CORRECTED: Ensure all three scopes are present
    private static final List<String> SCOPES = Arrays.asList(
        "https://www.googleapis.com/auth/gmail.send",     // Permission to send email
        "https://www.googleapis.com/auth/userinfo.email", // Permission to see email address
        "https://www.googleapis.com/auth/userinfo.profile"  // Permission to see name
    );

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        GoogleAuthorizationCodeRequestUrl url = new GoogleAuthorizationCodeRequestUrl(CLIENT_ID, REDIRECT_URI, SCOPES);
        url.setAccessType("offline");
        url.setApprovalPrompt("force"); // 'force' ensures the user sees the new permission request
        response.sendRedirect(url.build());
    }
}