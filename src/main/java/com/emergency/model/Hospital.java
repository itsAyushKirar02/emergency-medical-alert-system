package com.emergency.model;

public class Hospital {
    private int hospitalId;
    private String name;
    private double latitude;
    private double longitude;
    private String contactEmail;

    // --- Add Getters and Setters for all fields ---
    public int getHospitalId() { return hospitalId; }
    public void setHospitalId(int hospitalId) { this.hospitalId = hospitalId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }
    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }
    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }
}