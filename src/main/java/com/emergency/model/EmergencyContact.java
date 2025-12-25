package com.emergency.model;

public class EmergencyContact {
    private int contactId;
    private String name;
    private String phone;
    private String email;

    // --- Getters and Setters ---
    public int getContactId() { return contactId; }
    public void setContactId(int contactId) { this.contactId = contactId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}