<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Emergency Medical Alert System</title>
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
            height: 100vh;
            margin: 0;
            overflow: hidden; /* Hide overflow for background shapes */
        }
        .container {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.15);
            width: 100%;
            max-width: 380px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            z-index: 2;
        }
        h2 {
            margin-top: 0;
            margin-bottom: 30px;
            color: #333;
            font-weight: 700;
            font-size: 28px;
        }
        .input-group {
            position: relative;
            margin-bottom: 25px;
        }
        input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s;
        }
        input:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 4px rgba(0, 123, 255, 0.1);
        }
        button, .google-btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .login-btn {
            background-color: #007bff;
            color: white;
        }
        .login-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.3);
        }
        .google-btn {
            background-color: #ffffff;
            color: #444;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 15px;
            border: 1px solid #ddd;
            padding: 10px;
        }
        .google-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            border-color: #bbb;
        }
        .google-btn svg { width: 20px; height: 20px; }
        .separator { margin: 25px 0; display: flex; align-items: center; text-align: center; color: #888; }
        .separator::before, .separator::after { content: ''; flex: 1; border-bottom: 1px solid #ddd; }
        .separator:not(:empty)::before { margin-right: .5em; }
        .separator:not(:empty)::after { margin-left: .5em; }
        .error { color: #D8000C; background-color: #FFD2D2; padding: 10px; border-radius: 5px; margin-bottom: 20px;}
        a { color: #007bff; text-decoration: none; font-weight: 600; }
        
        /* New animated background shapes */
        .bg-shape {
            position: absolute;
            border-radius: 50%;
            background: linear-gradient(45deg, rgba(255,255,255,0.4), rgba(255,255,255,0.1));
            animation: float 20s infinite ease-in-out;
            z-index: 1;
        }
        .shape1 { width: 200px; height: 200px; top: 10%; left: 10%; animation-duration: 25s; }
        .shape2 { width: 100px; height: 100px; top: 70%; left: 80%; animation-duration: 18s; }
        .shape3 { width: 150px; height: 150px; top: 60%; left: 5%; animation-duration: 22s; }
        @keyframes float {
            0% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(180deg); }
            100% { transform: translateY(0) rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="bg-shape shape1"></div>
    <div class="bg-shape shape2"></div>
    <div class="bg-shape shape3"></div>

    <div class="container">
        <h2>Emergency Medical Alert System</h2>
        <% if ("1".equals(request.getParameter("error"))) { %>
            <p class="error">Invalid email or password. Please try again.</p>
        <% } %>
        <form action="LoginServlet" method="post">
            <div class="input-group">
                <input type="email" name="email" placeholder="Email Address" required>
            </div>
            <div class="input-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit" class="login-btn">Login</button>
        </form>
        <div class="separator">OR</div>
        <a href="GoogleSignInServlet" class="google-btn">
            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path fill="#4285F4" d="M43.611,20.083H42V20H24v8h11.303c-1.649,4.657-6.08,8-11.303,8c-6.627,0-12-5.373-12-12 c0-6.627,5.373-12,12-12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C12.955,4,4,12.955,4,24 c0,11.045,8.955,20,20,20c11.045,0,20-8.955,20-20C44,22.659,43.862,21.35,43.611,20.083z"></path><path fill="#34A853" d="M43.611,20.083H42V20H24v8h11.303c-0.792,2.237-2.231,4.166-4.087,5.571 c0.001-0.001,0.002-0.001,0.003-0.002l6.19,5.238C36.971,39.205,44,34,44,24C44,22.659,43.862,21.35,43.611,20.083z"></path><path fill="#FBBC05" d="M6.306,14.691l6.571,4.819C14.655,15.108,18.961,12,24,12c3.059,0,5.842,1.154,7.961,3.039 l5.657-5.657C34.046,6.053,29.268,4,24,4C16.318,4,9.656,8.337,6.306,14.691z"></path><path fill="#EA4335" d="M24,44c5.166,0,9.86-1.977,13.409-5.192l-6.19-5.238c-2.008,1.521-4.504,2.43-7.219,2.43 c-5.202,0-9.619-3.317-11.283-7.946l-6.522,5.025C9.505,39.556,16.227,44,24,44z"></path><path fill="none" d="M48,0v48H0V0H48z"></path></svg>
            <span>Sign in with Google</span>
        </a>
        <p style="margin-top: 20px;">Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>
</body>
</html>