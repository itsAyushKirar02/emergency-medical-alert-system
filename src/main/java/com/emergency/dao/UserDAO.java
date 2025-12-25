package com.emergency.dao;

import com.emergency.model.EmergencyContact;
import com.emergency.model.User;
import com.emergency.util.DBUtil;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private String hashPassword(String password) {
        if (password == null || password.equals("GOOGLE_LOGGED_IN")) {
            return "GOOGLE_LOGGED_IN";
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] messageDigest = md.digest(password.getBytes());
            BigInteger no = new BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean registerUserWithPassword(User user) {
        String sql = "INSERT INTO users (full_name, email, password, medical_doc_path) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashPassword(user.getPassword()));
            ps.setString(4, user.getMedicalDocPath());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User validateUserPassword(String email, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashPassword(password));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setMedicalDocPath(rs.getString("medical_doc_path"));
                    user.setGoogleRefreshToken(rs.getString("google_refresh_token"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public User getUserByEmail(String email) {
        User user = null;
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setMedicalDocPath(rs.getString("medical_doc_path"));
                    user.setGoogleRefreshToken(rs.getString("google_refresh_token"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public User getUserById(int userId) {
        User user = null;
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setMedicalDocPath(rs.getString("medical_doc_path"));
                    user.setGoogleRefreshToken(rs.getString("google_refresh_token"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public User createUserAndReturn(User user) {
        String sql = "INSERT INTO users (full_name, email, password, medical_doc_path, google_refresh_token) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getMedicalDocPath());
            ps.setString(5, user.getGoogleRefreshToken());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt(1));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void saveRefreshToken(int userId, String refreshToken) {
        String sql = "UPDATE users SET google_refresh_token = ? WHERE user_id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, refreshToken);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addEmergencyContact(int userId, EmergencyContact contact) {
        String sql = "INSERT INTO emergency_contacts (user_id, contact_name, contact_phone, email) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, contact.getName());
            ps.setString(3, contact.getPhone());
            ps.setString(4, contact.getEmail());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<EmergencyContact> getEmergencyContacts(int userId) {
        List<EmergencyContact> contacts = new ArrayList<>();
        String sql = "SELECT * FROM emergency_contacts WHERE user_id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    EmergencyContact contact = new EmergencyContact();
                    contact.setContactId(rs.getInt("contact_id"));
                    contact.setName(rs.getString("contact_name"));
                    contact.setPhone(rs.getString("contact_phone"));
                    contact.setEmail(rs.getString("email"));
                    contacts.add(contact);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contacts;
    }
}