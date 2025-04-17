<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Efficio | Smart Workflow Solutions</title>
     <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/views/assets/images/favicon.png">
   

    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/index/style.css">
    
</head>
<body>
    <!-- Navigation Bar -->
    <div class="navbar">
        <div class="container">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/views/assets/images/favicon.png" alt="Efficio Logo">
                <a href="#home" class="home-link">Home</a>
            </div>
            <div class="hamburger">&#8801;</div>
            <div class="nav-links">
                <a href="#services">Services</a>
                <a href="#about">About</a>
                <a href="#contact">Contact</a>
                <a href="LoginServlet">Login</a>
                <a href="UserRegisterServlet">Register</a>
            </div>
        </div>
    </div>

    <!-- Hero Section (Home) -->
    <div class="hero" id="home">
        <div class="hero-content">
            <h1>Efficio - Work Smarter</h1>
            <p>Manage tasks, projects, and employees seamlessly with one powerful system.</p>
            <a href="#contact" class="btn">Get Started</a>
        </div>
    </div>

    <!-- Services Section -->
    <div class="section services" id="services">
        <h2>Our Services</h2>
        <p>Streamline your workflow with Efficio's all-in-one management tools.</p>
        <div class="service-grid">
            <div class="service-card">
                <img src="${pageContext.request.contextPath}/views/assets/images/Taskindex.jpg" alt="Task Management">
                <h3>Task Management</h3>
                <p>Assign and track tasks easily.</p>
            </div>
            <div class="service-card">
                <img src="${pageContext.request.contextPath}/views/assets/images/Projectindex.jpg" alt="Project Management">
                <h3>Project Management</h3>
                <p>Keep projects on track.</p>
            </div>
            <div class="service-card">
                <img src="${pageContext.request.contextPath}/views/assets/images/Empindex.jpg" alt="Employee Management">
                <h3>Employee Management</h3>
                <p>Boost team productivity.</p>
            </div>
        </div>
    </div>

    <!-- About Section -->
    <div class="section about" id="about">
        <h2>About Efficio</h2>
        <div class="about-content">
            <img src="${pageContext.request.contextPath}/views/assets/images/Aboutindex.jpg" alt="Efficio Team">
            <p>Welcome to Efficio – your smart solution for effortless task, project, and employee management. Built with cutting-edge tech, we provide an intuitive interface and robust backend to keep your workflow smooth and productive.</p>
        </div>
    </div>

    <!-- Contact Section -->
    <div class="section contact" id="contact">
        <h2>Contact Us</h2>
        <p>Need help or want to know more? Drop us a message and let’s get you started with Efficio!</p>
        <form action="ContactServlet" method="POST">
            <input type="text" name="name" placeholder="Your Full Name" autocomplete="name" required>
            <input type="email" name="email" placeholder="Your Email Address" autocomplete="email" required>
            <textarea name="message" placeholder="Tell us how we can assist you" autocomplete="off" required></textarea>
            <button type="submit">Send Message</button>
        </form>
    </div>

    <!-- Footer -->
    <footer>
        <p>&copy; 2025 Efficio - Built for Efficiency, Designed for Success</p>
    </footer>
    
    <script src="${pageContext.request.contextPath}/views/assets/js/indexjs/script.js"></script>
</body>
</html>