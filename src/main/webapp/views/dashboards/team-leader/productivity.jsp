<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="in.efficio.model.DashboardStats"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Team Leader Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        /* Color Variables */
        :root {
            --primary-purple: #6b48ff;
            --background-light: #f4f4f9;
            --white: #fff;
            --accent-pink: #ff6b81;
            --border-gray: #e5e7eb;
            --text-dark: #2c3e50;
            --success-green: #28a745;
            --danger-red: #dc3545;
            --box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            --border-radius: 12px;
            --font-family: 'Inter', 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        /* Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            transition: all 0.3s ease-in-out;
        }

        /* Main Heading */
        h1 {
            font-size: 2.5rem;
            color: var(--primary-purple);
            text-align: center;
            margin: 20px 0;
            font-family: var(--font-family);
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }

        h1::after {
            content: '';
            width: 100px;
            height: 4px;
            background: var(--accent-pink);
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 2px;
        }

        /* Productivity Container */
        .productivity-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Productivity Card */
        .productivity-card {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 20px;
            text-align: center;
            position: relative;
            overflow: hidden;
            border-top: 4px solid;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .productivity-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        /* Card Colors */
        .productivity-card.completed {
            border-color: var(--success-green);
            background: linear-gradient(135deg, #ffffff, #e6f4ea);
        }

        .productivity-card.pending {
            border-color: var(--danger-red);
            background: linear-gradient(135deg, #ffffff, #fee2e2);
        }

        .productivity-card.productivity {
            border-color: var(--primary-purple);
            background: linear-gradient(135deg, #ffffff, #f3e8ff);
        }

        /* Card Icon */
        .productivity-card i {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: var(--text-dark);
        }

        .productivity-card.completed i {
            color: var(--success-green);
        }

        .productivity-card.pending i {
            color: var(--danger-red);
        }

        .productivity-card.productivity i {
            color: var(--primary-purple);
        }

        /* Card Title */
        .productivity-card h3 {
            font-size: 1.2rem;
            color: var(--text-dark);
            margin-bottom: 10px;
            font-weight: 500;
            font-family: var(--font-family);
        }

        /* Card Value */
        .productivity-card p {
            font-size: 2rem;
            font-weight: 600;
            color: var(--primary-purple);
            margin: 10px 0 0;
        }

        .productivity-card.completed p {
            color: var(--success-green);
        }

        .productivity-card.pending p {
            color: var(--danger-red);
        }

        /* Progress Bar */
        .productivity-card.productivity .progress-bar {
            width: 100%;
            height: 12px;
            background: var(--border-gray);
            border-radius: 6px;
            overflow: hidden;
            margin: 10px 0;
        }

        .productivity-card.productivity .progress-fill {
            height: 100%;
            background: linear-gradient(135deg, var(--primary-purple), #8b5cf6);
            transition: width 0.5s ease;
        }

        .productivity-card.productivity .progress-fill:hover {
            box-shadow: 0 0 10px rgba(107, 72, 255, 0.5);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .productivity-container {
                grid-template-columns: 1fr;
                padding: 15px;
            }

            .productivity-card {
                padding: 15px;
            }

            .productivity-card i {
                font-size: 2rem;
            }

            .productivity-card h3 {
                font-size: 1.1rem;
            }

            .productivity-card p {
                font-size: 1.8rem;
            }

            h1 {
                font-size: 2rem;
            }
        }

        @media (max-width: 480px) {
            .productivity-container {
                padding: 10px;
            }

            .productivity-card {
                padding: 12px;
            }

            .productivity-card i {
                font-size: 1.8rem;
            }

            .productivity-card h3 {
                font-size: 1rem;
            }

            .productivity-card p {
                font-size: 1.6rem;
            }

            .productivity-card.productivity .progress-bar {
                height: 10px;
            }

            h1 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
<h1><i class="fas fa-chart-bar"></i> Productivity</h1>
<div class="productivity-container">
    <% DashboardStats stats = (DashboardStats) request.getAttribute("stats"); %>
    <div class="productivity-card completed">
        <i class="fas fa-check-circle"></i>
        <h3>Completed Tasks</h3>
        <p><%= stats.getCompletedTaskCount() %></p>
    </div>
    <div class="productivity-card pending">
        <i class="fas fa-clock"></i>
        <h3>Pending Tasks</h3>
        <p><%= stats.getPendingTaskCount() %></p>
    </div>
    <div class="productivity-card productivity">
        <i class="fas fa-chart-line"></i>
        <h3>Productivity</h3>
        <div class="progress-bar">
            <div class="progress-fill" style="width: <%= String.format("%.1f", stats.getProductivity()) %>%;"></div>
        </div>
        <p><%= String.format("%.1f", stats.getProductivity()) %>%</p>
    </div>
</div>
</body>
</html>