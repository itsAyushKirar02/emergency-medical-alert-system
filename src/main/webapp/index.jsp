<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Emergency Medical Alert System - Stay Safe</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #e74c3c;
            --secondary-color: #3498db;
            --dark-color: #2c3e50;
            --light-color: #f4f7f6;
            --white: #ffffff;
        }
        html { scroll-behavior: smooth; }
        body { font-family: 'Poppins', sans-serif; margin: 0; background: var(--white); color: var(--dark-color); line-height: 1.6; }
        .container { max-width: 1100px; margin: auto; padding: 0 20px; }

        /* --- HERO SECTION --- */
        .hero {
            position: relative;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: var(--white);
            background: linear-gradient(135deg, #6dd5ed, #2193b0, #007bff, #e74c3c);
            background-size: 400% 400%;
            animation: backgroundGradient 15s ease infinite;
        }
        @keyframes backgroundGradient { 0%{background-position:0% 50%} 50%{background-position:100% 50%} 100%{background-position:0% 50%} }
        .hero::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(44, 62, 80, 0.65); z-index: 1; }
        .hero-content { position: relative; z-index: 2; max-width: 800px; padding: 20px; animation: fadeIn 1.5s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .hero .welcome-text {
            font-size: 1.5em;
            font-weight: 300;
            margin-bottom: 0;
            opacity: 0.9;
        }
        .hero h1 {
            font-size: 4.5em;
            margin: 10px 0;
            font-weight: 700;
            text-shadow: 2px 2px 10px rgba(0,0,0,0.5);
            color: #d0eaff; /* Light blue color from image */
        }
        .hero .subtitle {
            font-size: 1.4em;
            margin-bottom: 40px;
            font-weight: 300;
        }
        
        .cta-buttons a {
            display: inline-block;
            color: var(--white);
            padding: 15px 35px;
            margin: 10px 15px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1em;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            border: 2px solid transparent;
        }
        .cta-buttons a.btn-login { background-color: var(--primary-color); }
        .cta-buttons a.btn-register { background-color: var(--secondary-color); }
        .cta-buttons a:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
            background: var(--white);
        }
        .cta-buttons a.btn-login:hover { color: var(--primary-color); border-color: var(--primary-color); }
        .cta-buttons a.btn-register:hover { color: var(--secondary-color); border-color: var(--secondary-color); }

        /* --- CONTENT SECTIONS --- */
        .section { padding: 80px 0; }
        .section-title { text-align: center; font-size: 2.8em; margin-bottom: 50px; font-weight: 700; }
        
        .features { background-color: var(--light-color); }
        .features-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; }
        .feature-card { background: var(--white); padding: 30px; border-radius: 12px; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.05); transition: transform 0.3s, box-shadow 0.3s; }
        .feature-card:hover { transform: translateY(-10px); box-shadow: 0 12px 30px rgba(0,0,0,0.1); }
        .feature-card .icon {
            font-size: 3em;
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, var(--secondary-color), #8e44ad);
            color: var(--white);
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.4);
            transition: transform 0.3s;
        }
        .feature-card:hover .icon { transform: rotate(15deg) scale(1.1); }
        .feature-card h3 { font-size: 1.5em; margin-bottom: 10px; }
        
        .how-it-works { background: var(--white); }
        .steps { display: flex; justify-content: space-around; text-align: center; gap: 30px; margin-top: 60px; }
        .step { flex: 1; max-width: 300px; }
        .step .step-number { font-size: 2.5em; font-weight: 700; color: var(--white); background-color: var(--secondary-color); width: 70px; height: 70px; margin: 0 auto 20px; border-radius: 50%; display: flex; justify-content: center; align-items: center; border: 4px solid var(--light-color); box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3); }
        .step h3 { font-size: 1.5em; }
        
        footer { background: var(--dark-color); color: var(--white); text-align: center; padding: 25px 0; }
        
        @media (max-width: 768px) {
            .hero h1 { font-size: 3em; }
            .hero .subtitle, .hero .welcome-text { font-size: 1.1em; }
            .cta-buttons a { margin: 10px 0; display: block; width: 80%; max-width: 250px; }
            .cta-buttons { display: flex; flex-direction: column; align-items: center; }
            .steps { flex-direction: column; align-items: center; }
        }
    </style>
</head>
<body>
    <header class="hero">
        <div class="hero-content">
            <p class="welcome-text">Welcome to the Emergency Medical Alert System</p>
            <h1>Your Safety, Our Priority</h1>
            <p class="subtitle">Get instant medical alerts to your contacts and nearby hospitals with just one click.</p>
            <div class="cta-buttons">
                <a href="login.jsp" class="btn-login">Login Securely</a>
                <a href="register.jsp" class="btn-register">Register Now</a>
            </div>
        </div>
    </header>

    <main>
        <section class="section features">
            <div class="container">
                <h2 class="section-title">Why Choose Our System?</h2>
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="icon">📍</div>
                        <h3>Live Location Sharing</h3>
                        <p>Your exact GPS location is sent with every alert, ensuring help can find you quickly.</p>
                    </div>
                    <div class="feature-card">
                        <div class="icon">🏥</div>
                        <h3>Nearby Hospital Search</h3>
                        <p>Our system automatically finds and notifies registered hospitals within a 10km radius.</p>
                    </div>
                    <div class="feature-card">
                        <div class="icon">📄</div>
                        <h3>Medical Document Link</h3>
                        <p>Your uploaded medical document is securely sent to responders, providing critical health information.</p>
                    </div>
                </div>
            </div>
        </section>
        
        <section class="section how-it-works">
            <div class="container">
                <h2 class="section-title">How It Works in 3 Simple Steps</h2>
                <div class="steps">
                    <div class="step">
                        <div class="step-number">1</div>
                        <h3>Register & Set Up</h3>
                        <p>Create your account, upload your medical info, and add your emergency contacts.</p>
                    </div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <h3>Press the SOS Button</h3>
                        <p>In an emergency, log in and press the SOS button on your dashboard.</p>
                    </div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <h3>Help is Notified</h3>
                        <p>Alerts are instantly sent to your contacts and nearby hospitals with your location and medical data.</p>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer>
        <p>&copy; 2025 Emergency Medical Alert System. All Rights Reserved.</p>
    </footer>
</body>
</html>