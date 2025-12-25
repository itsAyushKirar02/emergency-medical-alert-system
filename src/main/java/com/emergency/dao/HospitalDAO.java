package com.emergency.dao;

import com.emergency.model.Hospital;
import com.emergency.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HospitalDAO {

    /**
     * Finds all hospitals within a given radius (in kilometers) of a user's location.
     * @param userLat The user's latitude.
     * @param userLng The user's longitude.
     * @param radiusKm The search radius in kilometers.
     * @return A list of nearby Hospital objects.
     */
    public List<Hospital> findNearbyHospitals(double userLat, double userLng, int radiusKm) {
        List<Hospital> nearbyHospitals = new ArrayList<>();
        
        // This SQL query uses the spherical law of cosines (a form of the Haversine formula) 
        // to calculate the distance in kilometers between the user and each hospital.
        // The `HAVING` clause then filters out any hospitals that are outside the desired radius.
        String sql = "SELECT *, " +
                     "( 6371 * acos( cos( radians(?) ) * cos( radians( latitude ) ) * " +
                     "cos( radians( longitude ) - radians(?) ) + sin( radians(?) ) * " +
                     "sin( radians( latitude ) ) ) ) AS distance " +
                     "FROM hospitals HAVING distance < ? ORDER BY distance";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            // Set the parameters for the query
            ps.setDouble(1, userLat);   // user's latitude
            ps.setDouble(2, userLng);   // user's longitude
            ps.setDouble(3, userLat);   // user's latitude again
            ps.setInt(4, radiusKm);     // the radius (e.g., 10)

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Hospital hospital = new Hospital();
                    hospital.setHospitalId(rs.getInt("hospital_id"));
                    hospital.setName(rs.getString("hospital_name"));
                    hospital.setLatitude(rs.getDouble("latitude"));
                    hospital.setLongitude(rs.getDouble("longitude"));
                    hospital.setContactEmail(rs.getString("contact_email"));
                    nearbyHospitals.add(hospital);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nearbyHospitals;
    }
}