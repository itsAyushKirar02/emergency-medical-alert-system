<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.emergency.model.EmergencyContact" %>
<%
    if (session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
    String fullName = (String) session.getAttribute("fullName");
    List<EmergencyContact> contacts = (List<EmergencyContact>) request.getAttribute("contacts");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Emergency Medical Alert System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            box-sizing: border-box;
            overflow-x: hidden;
        }
        .container { 
            max-width: 800px; 
            margin: auto;
            position: relative;
            z-index: 2;
        }
        .form-section {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: formEntry 0.7s ease-out;
        }
        @keyframes formEntry { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; translateY(0); } }

        h1, h2 { color: #333; font-weight: 700; }
        h1 { text-align: center; margin-bottom: 30px; }
        h2 { border-bottom: 2px solid #007bff; padding-bottom: 10px; margin-top: 0; }
        p { color: #666; font-size: 14px; line-height: 1.5; }
        
        .back-link { 
            display: inline-block; margin-bottom: 20px; font-weight: 600; 
            color: #007bff; text-decoration: none; transition: transform 0.3s;
        }
        .back-link:hover { transform: translateX(-5px); }

        /* Floating Label Styles */
        .input-group { position: relative; margin-bottom: 25px; }
        .input-group input {
            width: 100%; padding: 12px 15px; border: 1px solid #ccc;
            border-radius: 8px; box-sizing: border-box; font-family: 'Poppins', sans-serif;
            font-size: 16px; background-color: white; 
        }
        .input-group label {
            position: absolute; top: 13px; left: 15px; color: #888;
            pointer-events: none; transition: all 0.2s ease-in-out;
        }
        .input-group input:not(:placeholder-shown) + label,
        .input-group input:focus + label,
        .input-group input:-webkit-autofill + label {
            top: -10px; left: 10px; font-size: 12px; color: #007bff;
            background-color: white; padding: 0 5px;
        }
        .input-group input:-webkit-autofill { -webkit-box-shadow: 0 0 0 30px white inset !important; }
        .input-group input:focus { 
            outline: none; border-color: #007bff; 
            box-shadow: 0 0 0 4px rgba(0, 123, 255, 0.1);
        }

        button {
            background: linear-gradient(90deg, #007bff, #0056b3);
            color: white; padding: 12px 18px;
            border: none; border-radius: 8px; cursor: pointer;
            font-size: 16px; font-weight: 600; transition: all 0.3s ease;
        }
        button:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.3);
        }

        /* Your Original Google Button Styles (Unchanged) */
        .google-btn { background-color: #ffffff; color: #444; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 10px; border: 1px solid #ddd; padding: 10px; font-weight: 600; transition: all 0.3s ease; border-radius: 8px; cursor: pointer; }
        .google-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); border-color: #bbb; }
        .google-btn svg { width: 20px; height: 20px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border-bottom: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f8f9fa; font-weight: 600; }
        
        /* Animated background shapes */
        .bg-shape { position: absolute; border-radius: 50%; background: linear-gradient(45deg, rgba(255,255,255,0.5), rgba(255,255,255,0.2)); animation: float 20s infinite ease-in-out; z-index: 1; }
        .shape1 { width: 250px; height: 250px; top: 5%; left: 5%; animation-duration: 25s; }
        .shape2 { width: 150px; height: 150px; top: 80%; left: 85%; animation-duration: 18s; }
        @keyframes float { 0% { transform: translateY(0); } 50% { transform: translateY(-20px); } 100% { transform: translateY(0); } }
    </style>
</head>
<body>
    <div class="bg-shape shape1"></div>
    <div class="bg-shape shape2"></div>

    <div class="container">
        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
        <h1>Hello, <%= fullName %>!</h1>
        <div class="form-section">
            <h2>Connect Your Gmail Account</h2>
            <p>Authorize this app to send emergency alerts from your Gmail. You only need to do this once.</p>
            <a href="GoogleSignInServlet" class="google-btn">
                <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path fill="#4285F4" d="M43.611,20.083H42V20H24v8h11.303c-1.649,4.657-6.08,8-11.303,8c-6.627,0-12-5.373-12-12 c0-6.627,5.373-12,12-12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C12.955,4,4,12.955,4,24 c0,11.045,8.955,20,20,20c11.045,0,20-8.955,20-20C44,22.659,43.862,21.35,43.611,20.083z"></path><path fill="#34A853" d="M43.611,20.083H42V20H24v8h11.303c-0.792,2.237-2.231,4.166-4.087,5.571 c0.001-0.001,0.002-0.001,0.003-0.002l6.19,5.238C36.971,39.205,44,34,44,24C44,22.659,43.862,21.35,43.611,20.083z"></path><path fill="#FBBC05" d="M6.306,14.691l6.571,4.819C14.655,15.108,18.961,12,24,12c3.059,0,5.842,1.154,7.961,3.039 l5.657-5.657C34.046,6.053,29.268,4,24,4C16.318,4,9.656,8.337,6.306,14.691z"></path><path fill="#EA4335" d="M24,44c5.166,0,9.86-1.977,13.409-5.192l-6.19-5.238c-2.008,1.521-4.504,2.43-7.219,2.43 c-5.202,0-9.619-3.317-11.283-7.946l-6.522,5.025C9.505,39.556,16.227,44,24,44z"></path><path fill="none" d="M48,0v48H0V0H48z"></path></svg>
                <span>Connect with Google</span>
            </a>
        </div>
        <div class="form-section">
            <h2>Add New Emergency Contact</h2>
            <form action="AddContactServlet" method="post">
                <div class="input-group">
                    <input type="text" id="contactName" name="contactName" placeholder=" " required>
                    <label for="contactName">Contact's Full Name</label>
                </div>
                <div class="input-group">
                    <input type="tel" id="contactPhone" name="contactPhone" placeholder=" " required>
                    <label for="contactPhone">Contact's Phone Number</label>
                </div>
                <div class="input-group">
                    <input type="email" id="contactEmail" name="contactEmail" placeholder=" " required>
                    <label for="contactEmail">Contact's Email</label>
                </div>
                <button type="submit">Add Contact</button>
            </form>
        </div>
        <div class="form-section">
            <h2>Your Emergency Contacts</h2>
            <table>
                <thead><tr><th>Name</th><th>Phone</th><th>Email</th></tr></thead>
                <tbody>
                    <% if (contacts != null && !contacts.isEmpty()) {
                        for (EmergencyContact contact : contacts) { %>
                            <tr><td><%= contact.getName() %></td><td><%= contact.getPhone() %></td><td><%= contact.getEmail() %></td></tr>
                    <%  } } else { %>
                            <tr><td colspan="3" style="text-align: center; color: #777;">No contacts added yet.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>