package com.emergency.dao;

import com.emergency.util.DBUtil;
import org.json.JSONArray;
import org.json.JSONObject;
import java.sql.*;

public class AlertDAO {

	public void createAlert(int userId, double lat, double lng) {
		// This method remains the same
		String sql = "INSERT INTO alerts (user_id, latitude, longitude, status) VALUES (?, ?, ?, 'Active')";
		try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setDouble(2, lat);
			ps.setDouble(3, lng);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// MODIFIED: This now only gets unclaimed alerts
	public String getUnclaimedAlertsAsJson() {
	    JSONArray alertsArray = new JSONArray();
	    // MODIFIED: Added u.user_id to the SELECT statement
	    String sql = "SELECT a.alert_id, u.user_id, u.full_name, u.medical_doc_path, a.latitude, a.longitude " +
	                 "FROM alerts a JOIN users u ON a.user_id = u.user_id " +
	                 "WHERE a.status = 'Active' ORDER BY a.alert_time DESC";
	    try (Connection con = DBUtil.getConnection();
	         Statement stmt = con.createStatement();
	         ResultSet rs = stmt.executeQuery(sql)) {
	        while (rs.next()) {
	            JSONObject alert = new JSONObject();
	            alert.put("alertId", rs.getInt("alert_id"));
	            alert.put("userId", rs.getInt("user_id")); // <-- ADD THIS LINE
	            alert.put("fullName", rs.getString("full_name"));
	            alert.put("medicalDocPath", rs.getString("medical_doc_path"));
	            alert.put("lat", rs.getDouble("latitude"));
	            alert.put("lng", rs.getDouble("longitude"));
	            alertsArray.put(alert);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return alertsArray.toString();
	}

	// NEW: Method to claim an alert
	public boolean claimAlert(int alertId, int hospitalId) {
		// This query ensures that two hospitals can't claim the same alert at the same
		// time
		String sql = "UPDATE alerts SET status = 'Acknowledged', acknowledged_by_hospital_id = ? "
				+ "WHERE alert_id = ? AND status = 'Active'";
		try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, hospitalId);
			ps.setInt(2, alertId);
			// executeUpdate() returns the number of rows affected.
			// If it's > 0, the claim was successful.
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
}