<%-- This directive disables JSP Expression Language --%>
<%@ page isELIgnored="true" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String fullName = (String) session.getAttribute("fullName");
//    String apiKey = application.getInitParameter("GOOGLE_MAPS_API_KEY");
    String apiKey = System.getenv("GOOGLE_MAPS_API_KEY");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Emergency Medical Alert System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Poppins', sans-serif; 
            margin: 0;
            background-color: #f4f7f6;
            overflow: hidden;
        }

        /* Animated Background */
        .aurora-background {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            --aurora-color-1: rgba(0, 123, 255, 0.2);
            --aurora-color-2: rgba(231, 76, 60, 0.2);
            background: radial-gradient(40% 60% at 20% 25%, var(--aurora-color-1), transparent),
                        radial-gradient(40% 60% at 80% 75%, var(--aurora-color-2), transparent);
            animation: aurora 20s infinite alternate;
            z-index: 0;
        }
        @keyframes aurora { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }

        /* Glassmorphism Header */
        #header { 
            background: rgba(52, 58, 64, 0.85);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            color: white; 
            padding: 10px 25px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.2); 
            z-index: 99999;  /* CORRECTED: Set a very high z-index */
            position: relative;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        #header a { 
            color: #d1e7ff; text-decoration: none; margin-left: 20px; 
            font-weight: 600; transition: color 0.3s; 
        }
        #header a:hover { color: #ffffff; text-shadow: 0 0 5px rgba(255,255,255,0.5); }

        #map { 
            height: 100vh; width: 100vw;
            position: absolute; top: 0; left: 0;
            z-index: 1; /* Sits below the header */
        }
        
        /* --- ADDED BACK: SOS Button Styles --- */
        #sosButton {
            position: fixed; bottom: 40px; right: 40px;
            width: 100px; height: 100px;
            background: radial-gradient(circle, #ff416c, #ff4b2b);
            color: white; font-size: 28px; font-weight: 700;
            border: 3px solid white; border-radius: 50%;
            cursor: pointer; box-shadow: 0 5px 20px rgba(255, 75, 43, 0.5);
            animation: pulse 1.5s infinite;
            display: flex; justify-content: center; align-items: center;
            transition: all 0.3s ease;
            z-index: 10;
        }
        #sosButton:hover { transform: scale(1.1); animation-play-state: paused; }
        #sosButton:disabled { background: #6c757d; cursor: not-allowed; animation: none; transform: scale(1); box-shadow: none; }
        @keyframes pulse { 0% { box-shadow: 0 0 0 0 rgba(255, 75, 43, 0.7); } 70% { box-shadow: 0 0 0 30px rgba(255, 75, 43, 0); } 100% { box-shadow: 0 0 0 0 rgba(255, 75, 43, 0); } }
        
        /* --- ADDED BACK: Notification Banner Styles --- */
        #notification { 
            position: fixed; top: -150px; left: 50%; 
            transform: translateX(-50%); 
            background-color: #333; color: white; 
            padding: 15px 25px; border-radius: 8px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.2); 
            transition: top 0.5s ease-in-out; 
            z-index: 10000; /* Higher than header */
            text-align: center; max-width: 90%; 
        }
        #notification.show { top: 65px; }
        #notification.error { background-color: #d9534f; }
        #notification.success { background-color: #28a745; }
        
        .map-controls { 
            background-color: transparent; border-radius: 8px; 
            overflow: hidden; border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .map-controls button { 
            background: rgba(0,0,0,0.2); color: #d1e7ff; border: none;
            border-left: 1px solid rgba(255, 255, 255, 0.1);
            padding: 8px 15px; cursor: pointer; 
            font-family: 'Poppins', sans-serif; font-weight: 600; 
            font-size: 14px; transition: all 0.3s; 
        }
        .map-controls button:first-child { border-left: none; }
        .map-controls button.active, .map-controls button:hover { 
            background-color: #007bff; color: white; 
            text-shadow: 0 0 5px rgba(255,255,255,0.5);
        }
    </style>
</head>
<body>
    <div class="aurora-background"></div>

    <div id="header">
        <span>Welcome, <strong><%= fullName %></strong>!</span>
        <div class="map-controls">
            <button id="btnRoadmap" class="active">Map</button>
            <button id="btnSatellite">Satellite</button>
            <button id="btnTerrain">Terrain</button>
        </div>
        <div>
            <a href="ProfileServlet">Manage Contacts</a>
            <a href="LogoutServlet">Logout</a>
        </div>
    </div>
    <div id="map"></div>
    
    <button id="sosButton">SOS</button>
    
    <div id="notification"></div>

    <script async defer src="https://maps.googleapis.com/maps/api/js?key=<%= apiKey %>&callback=initMap"></script>
    <script>
        // The JavaScript does not need to be changed.
        const sosButton = document.getElementById('sosButton');
        const notification = document.getElementById('notification');
        let map, userMarker;
        let currentUserPosition = null;

        function showNotification(message, type = 'info') {
            notification.innerHTML = message;
            notification.className = type;
            notification.classList.add('show');
            setTimeout(() => { notification.classList.remove('show'); }, 6000);
        }

        function initMap() {
            map = new google.maps.Map(document.getElementById('map'), {
                center: { lat: 22.7196, lng: 75.8577 },
                zoom: 15,
                streetViewControl: false,
                mapTypeControl: false,
                fullscreenControl: false,
                zoomControl: false
            });
            const btnRoadmap = document.getElementById('btnRoadmap');
            const btnSatellite = document.getElementById('btnSatellite');
            const btnTerrain = document.getElementById('btnTerrain');
            btnRoadmap.addEventListener('click', () => map.setMapTypeId('roadmap'));
            btnSatellite.addEventListener('click', () => map.setMapTypeId('hybrid'));
            btnTerrain.addEventListener('click', () => map.setMapTypeId('terrain'));
            map.addListener('maptypeid_changed', () => {
                const currentType = map.getMapTypeId();
                document.querySelectorAll('.map-controls button').forEach(btn => btn.classList.remove('active'));
                if (currentType === 'roadmap') btnRoadmap.classList.add('active');
                if (currentType === 'hybrid') btnSatellite.classList.add('active');
                if (currentType === 'terrain') btnTerrain.classList.add('active');
            });
            if (navigator.geolocation) {
                navigator.geolocation.watchPosition(position => {
                    currentUserPosition = { lat: position.coords.latitude, lng: position.coords.longitude };
                    if (!userMarker) { 
                        // Added animation to the user's marker
                        userMarker = new google.maps.Marker({ 
                            map: map, 
                            title: "Your Location",
                            animation: google.maps.Animation.DROP 
                        }); 
                    }
                    userMarker.setPosition(currentUserPosition);
                    map.setCenter(currentUserPosition);
                }, () => showNotification("Geolocation failed. Please enable location services.", 'error'), { enableHighAccuracy: true });
            } else {
                 showNotification("Your browser does not support geolocation.", 'error');
            }
        }

        sosButton.addEventListener('click', () => {
            if (!currentUserPosition) { 
                return showNotification("Cannot get your location yet. Please wait for the marker.", 'error'); 
            }
            if (confirm("Confirm: Send an emergency alert?")) {
                sosButton.disabled = true;
                sosButton.textContent = '...';
                const formData = new URLSearchParams();
                formData.append('lat', currentUserPosition.lat);
                formData.append('lng', currentUserPosition.lng);
                fetch('EmergencyAlertServlet', { method: 'POST', body: formData })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        let hospitalList = data.hospitalsNotified.length > 0 
                            ? `<br><br>Hospitals Notified:<br>- ${data.hospitalsNotified.join('<br>- ')}`
                            : '<br><br>No hospitals were found nearby.';
                        let successMessage = `Alert sent to ${data.contactsNotified} contact(s). ${hospitalList}`;
                        showNotification(successMessage, 'success');
                    } else {
                        showNotification(`Error: ${data.message || 'An unknown error occurred.'}`, 'error');
                    }
                })
                .catch(error => { 
                    console.error('Alert Error:', error); 
                    showNotification('A network error occurred. Please try again.', 'error'); 
                })
                .finally(() => { 
                    sosButton.disabled = false; 
                    sosButton.textContent = 'SOS'; 
                });
            }
        });
    </script>
</body>
</html>