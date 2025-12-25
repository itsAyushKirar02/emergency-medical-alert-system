<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Emergency Medical Alert System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
            overflow: hidden;
        }
        .container {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.15);
            width: 100%;
            max-width: 420px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            z-index: 2;
            animation: formEntry 0.7s ease-out;
        }
        @keyframes formEntry { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } }

        h2 { text-align: center; margin-top: 0; margin-bottom: 30px; color: #333; font-weight: 700; }
        
        /* --- Floating Label Styles --- */
        .input-group { position: relative; margin-bottom: 25px; }
        .input-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
            background-color: transparent; 
        }
        .input-group label {
            position: absolute;
            top: 13px;
            left: 15px;
            color: #888;
            pointer-events: none;
            transition: all 0.2s ease-in-out;
        }
        
        /* --- THIS IS THE FIX for the overlap --- */
        /* When input has text, is autofilled, OR is focused, float the label */
        .input-group input:not(:placeholder-shown) + label,
        .input-group input:focus + label,
        .input-group input:-webkit-autofill + label {
            top: -10px;
            left: 10px;
            font-size: 12px;
            color: #007bff;
            background-color: white;
            padding: 0 5px;
        }
        /* Style for autofilled background */
        .input-group input:-webkit-autofill,
        .input-group input:-webkit-autofill:hover, 
        .input-group input:-webkit-autofill:focus, 
        .input-group input:-webkit-autofill:active {
            -webkit-box-shadow: 0 0 0 30px white inset !important;
            box-shadow: 0 0 0 30px white inset !important;
        }

        .input-group input:focus { outline: none; border-color: #007bff; }
        .file-input-label { display: block; text-align: left; margin-bottom: 5px; font-weight: 600; font-size: 14px; color: #555; }
        
        button {
            width: 100%;
            background: linear-gradient(90deg, #28a745, #218838);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        button:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(40, 167, 69, 0.3); }
        .error { color: #D8000C; background-color: #FFD2D2; padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center;}
        
        /* Animated background shapes */
        .bg-shape { position: absolute; border-radius: 50%; background: linear-gradient(45deg, rgba(255,255,255,0.4), rgba(255,255,255,0.1)); animation: float 20s infinite ease-in-out; z-index: 1; }
        .shape1 { width: 200px; height: 200px; top: 10%; left: 10%; animation-duration: 25s; }
        .shape2 { width: 100px; height: 100px; top: 70%; left: 80%; animation-duration: 18s; }
        .shape3 { width: 150px; height: 150px; top: 60%; left: 5%; animation-duration: 22s; }
        @keyframes float { 0% { transform: translateY(0); } 50% { transform: translateY(-30px); } 100% { transform: translateY(0); } }
    </style>
</head>
<body>
    <div class="bg-shape shape1"></div>
    <div class="bg-shape shape2"></div>
    <div class="bg-shape shape3"></div>

    <div class="container">
        <h2>Create an Account</h2>
        <% if ("1".equals(request.getParameter("error"))) { %>
            <p class="error">Registration failed. This email may already be in use.</p>
        <% } %>
        <form action="RegisterServlet" method="post" enctype="multipart/form-data">
            <div class="input-group">
                <input type="text" id="fullName" name="fullName" placeholder=" " required>
                <label for="fullName">Full Name</label>
            </div>
            <div class="input-group">
                <input type="email" id="email" name="email" placeholder=" " required>
                <label for="email">Email</label>
            </div>
            <div class="input-group">
                <input type="password" id="password" name="password" placeholder=" " required>
                <label for="password">Password</label>
            </div>
            <label for="medicalDoc" class="file-input-label">Upload Medical Document:</label>
            <input type="file" id="medicalDoc" name="medicalDoc" required style="margin-bottom: 25px;">
            <button type="submit">Register</button>
        </form>
        <p style="text-align: center; margin-top: 20px;">Already have an account? <a href="login.jsp" style="font-weight: 600; color: #007bff;">Login here</a></p>
    </div>
</body>
</html>