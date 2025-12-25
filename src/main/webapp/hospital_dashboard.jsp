<%-- This directive disables JSP Expression Language --%>
<%@ page isELIgnored="true" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospital - Emergency Medical Alert System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            min-height: 100vh;
            overflow-x: hidden;
        }
        .header {
            background: #c82333;
            color: white;
            padding: 15px 20px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h1 { margin: 0; font-size: 24px; }
        .container { max-width: 1200px; margin: auto; padding: 20px; position: relative; z-index: 2;}

        .alert-card {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-left: 7px solid #d9534f;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: fadeIn 0.7s ease-out;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .alert-card:hover {
            transform: translateY(-5px) scale(1.01);
            box-shadow: 0 12px 40px rgba(0,0,0,0.15);
        }
        h3 { margin-top: 0; color: #d9534f; font-weight: 700; }
        .claim-btn {
            background: linear-gradient(90deg, #28a745, #218838);
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .claim-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }
        .claim-btn:disabled { background: #6c757d; cursor: not-allowed; transform: none; box-shadow: none; }
        #hospital-info {
            text-align: center; font-size: 1.2em; margin-bottom: 20px;
            color: #555; background: rgba(255, 255, 255, 0.7);
            padding: 10px; border-radius: 8px;
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        /* Animated background shapes */
        .bg-shape { position: absolute; border-radius: 50%; background: linear-gradient(45deg, rgba(255,255,255,0.5), rgba(255,255,255,0.2)); animation: float 20s infinite ease-in-out; z-index: 1; }
        .shape1 { width: 300px; height: 300px; top: -50px; left: -100px; animation-duration: 25s; }
        .shape2 { width: 200px; height: 200px; bottom: -50px; right: -50px; animation-duration: 18s; }
        @keyframes float { 0% { transform: translateY(0); } 50% { transform: translateY(-20px); } 100% { transform: translateY(0); } }
    </style>
</head>
<body>
    <div class="bg-shape shape1"></div>
    <div class="bg-shape shape2"></div>
    <div class="header"><h1>Active Emergency Medical Alerts</h1></div>
    <div class="container">
        <div id="hospital-info">Loading...</div>
        <div id="alertsContainer"><p>Checking for new alerts...</p></div>
    </div>
    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const hospitalId = urlParams.get('hospitalId');
        if (!hospitalId) {
            document.getElementById('hospital-info').innerHTML = '<p style="color:red; font-weight:bold;">Error: No Hospital ID provided. Access with a URL like ...?hospitalId=1</p>';
        } else {
             document.getElementById('hospital-info').innerHTML = `Viewing Dashboard as Hospital ID: <strong>${hospitalId}</strong>`;
        }
        
        function fetchUnclaimedAlerts() {
            if (!hospitalId) return;
            fetch('GetActiveAlertsServlet')
            .then(response => response.json())
            .then(alerts => {
                const container = document.getElementById('alertsContainer');
                container.innerHTML = '';
                if (alerts.length === 0) {
                    container.innerHTML = '<p style="text-align: center; color: #777;">No active alerts at this time.</p>';
                    return;
                }
                alerts.forEach(alert => {
                    // --- THIS IS THE CORRECTED LINE ---
                    const mapLink = `https://www.google.com/maps?q=${alert.lat},${alert.lng}`;
                    
                    let documentLink = 'No medical document uploaded.';
                    if (alert.medicalDocPath) {
                        documentLink = `<a href="DownloadDocumentServlet?userId=${alert.userId}" target="_blank" style="font-weight: bold;">Download Medical Document</a>`;
                    }

                    container.innerHTML += `
                        <div class="alert-card" id="alert-${alert.alertId}">
                            <h3>ALERT from: ${alert.fullName}</h3>
                            <p><strong>Medical Document:</strong> ${documentLink}</p>
                            <p><a href="${mapLink}" target="_blank" style="font-weight: bold;">View Live Location</a></p>
                            <button class="claim-btn" onclick="claimAlert(${alert.alertId})">Claim Alert</button>
                        </div>
                    `;
                });
            })
            .catch(error => console.error('Fetch Error:', error));
        }

        function claimAlert(alertId) {
            if (!hospitalId) { alert("Cannot claim alert: Hospital ID is missing."); return; }
            const claimButton = document.querySelector(`#alert-${alertId} .claim-btn`);
            claimButton.disabled = true;
            claimButton.textContent = 'Claiming...';
            const formData = new URLSearchParams();
            formData.append('alertId', alertId);
            formData.append('hospitalId', hospitalId);
            fetch('ClaimAlertServlet', { method: 'POST', body: formData })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
                fetchUnclaimedAlerts();
            })
            .catch(error => {
                console.error('Claim Error:', error);
                claimButton.disabled = false;
                claimButton.textContent = 'Claim Alert';
            });
        }
        setInterval(fetchUnclaimedAlerts, 7000);
        window.onload = fetchUnclaimedAlerts;
    </script>
</body>
</html>