# Efficio - Task, Project & Employee Management System

**Efficio** is a web-based employee, task, and project management system built using Java (JSP, Servlet), JDBC, and MySQL. It is designed to help small and medium-sized enterprises (SMEs) efficiently manage their teams, assign tasks, track progress, and generate feedback and reports in a centralized manner.

---

## 👨‍💻 Developer

- **Name:** Devendra Gadge  
- **Course:** MCA (IV Semester)  
- **Institute:** School of Computer Science & IT, Devi Ahilya Vishwavidyalaya, Indore  

---

## 📌 Table of Contents

- [About](#about)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [System Flow](#system-flow)
- [How to Run the Project](#how-to-run-the-project)
- [Screenshots](#screenshots)
- [License](#license)

---

## 📖 About

Efficio solves the inefficiencies of manual project and task management in SMEs. It allows:
- Role-based access for Admins, Team Leaders, and Employees.
- Real-time task tracking, deadline reminders, and feedback.
- A centralized dashboard for managing employee productivity.

---

## 🚀 Features

- 🔐 **Secure Login & Role-based Access**  
- 📋 **Admin Panel** – Manage users, create & assign projects/tasks  
- 👥 **Team Leader Panel** – Assign tasks, track progress, give feedback  
- 💼 **Employee Panel** – View tasks, update status, receive feedback  
- 📊 **Analytics & Reports** – Track performance and project status  
- 🔔 **Notifications** – Get updates on assignments and changes  
- 📆 **Deadline Tracking** – Tasks with date and priority  
- 📄 **Feedback System** – Automatic feedback after task completion  

---

## 🛠 Technologies Used

| Layer        | Technology                     |
|--------------|-------------------------------|
| Frontend     | HTML, CSS, JavaScript         |
| Backend      | Java (Servlets, JSP)          |
| Database     | MySQL                         |
| Connectivity | JDBC                          |
| IDE          | Eclipse IDE                   |
| Server       | Apache Tomcat (v9 recommended)|

---

## 🔁 System Flow

1. **Employee Registration** → Request goes to **Admin**
2. **Admin Approval** → ID generated → Assign **Team Leader**
3. **Team Leader** → Assigns project & tasks to employees
4. **Employees** → Update task status → Feedback generated
5. **Dashboards** → Role-based dashboards for each user

---

## 💻 How to Run the Project

1. Clone or Download the project.
2. Import the project in **Eclipse IDE**.
3. Create a **MySQL database** and import `database.sql` from the project.
4. Update database credentials in the `DatabaseConnection.java` file.
5. Deploy the project on **Apache Tomcat server**.
6. Run the application using:  
