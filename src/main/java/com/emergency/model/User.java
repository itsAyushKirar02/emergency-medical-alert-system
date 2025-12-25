package com.emergency.model;

public class User {
    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String medicalDocPath;
    private String googleRefreshToken; // <-- NEW FIELD

    // --- Getters and Setters ---
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getMedicalDocPath() { return medicalDocPath; }
    public void setMedicalDocPath(String medicalDocPath) { this.medicalDocPath = medicalDocPath; }
    public String getGoogleRefreshToken() { return googleRefreshToken; }
    public void setGoogleRefreshToken(String googleRefreshToken) { this.googleRefreshToken = googleRefreshToken; }
}