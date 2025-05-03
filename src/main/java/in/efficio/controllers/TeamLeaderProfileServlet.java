package in.efficio.controllers;

import in.efficio.dao.TeamLeaderDAO;
import in.efficio.dbconnection.DbConnection;
import in.efficio.model.TeamLeader;
import in.efficio.utils.PasswordHashing;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Logger;

@WebServlet("/TeamLeaderProfileServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class TeamLeaderProfileServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TeamLeaderProfileServlet.class.getName());
    private TeamLeaderDAO teamLeaderDAO;
    private static final String UPLOAD_DIR = "Uploads/profile_pictures";

    @Override
    public void init() {
        LOGGER.info("Initializing TeamLeaderProfileServlet");
        teamLeaderDAO = new TeamLeaderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("Received GET request to TeamLeaderProfileServlet");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            LOGGER.warning("No session or userName, redirecting to LogoutServlet");
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        Integer teamLeaderId = (Integer) session.getAttribute("teamLeaderId");
        if (teamLeaderId == null) {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                teamLeaderId = userId;
                session.setAttribute("teamLeaderId", teamLeaderId);
                LOGGER.info("Recovered teamLeaderId from userId: " + teamLeaderId);
            } else {
                LOGGER.severe("teamLeaderId and userId are null for user: " + session.getAttribute("userName"));
                response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Invalid session: Team Leader ID missing.");
                return;
            }
        }

        String role = (String) session.getAttribute("userRole");
        if (role == null) {
            LOGGER.severe("userRole is null for teamLeaderId: " + teamLeaderId);
            request.setAttribute("message", "Error: Role missing in session");
            request.setAttribute("alertType", "error");
            request.getRequestDispatcher("/views/dashboards/common/error.jsp").forward(request, response);
            return;
        }

        if (!"TeamLeader".equals(role)) {
            LOGGER.warning("Unauthorized access attempt by role: " + role + " for teamLeaderId: " + teamLeaderId);
            request.setAttribute("message", "Error: Unauthorized access");
            request.setAttribute("alertType", "error");
            request.getRequestDispatcher("/views/dashboards/common/error.jsp").forward(request, response);
            return;
        }

        TeamLeader user = teamLeaderDAO.getTeamLeaderById(teamLeaderId).orElse(null);
        if (user == null) {
            LOGGER.severe("User not found for teamLeaderId: " + teamLeaderId);
            request.setAttribute("message", "Error: User data not found");
            request.setAttribute("alertType", "error");
            request.getRequestDispatcher("/views/dashboards/common/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("user", user);
        String contentType = request.getParameter("contentType");
        request.setAttribute("contentType", contentType != null ? contentType : "settings");
        request.setAttribute("includePath", "/views/dashboards/team-leader/profile.jsp");
        LOGGER.info("Forwarding to TeamLeaderDashboard.jsp with /views/dashboards/team-leader/profile.jsp for teamLeaderId: " + teamLeaderId);
        request.getRequestDispatcher("/views/dashboards/team-leader/TeamLeaderDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("Received POST request to TeamLeaderProfileServlet");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userName") == null) {
            LOGGER.warning("No session or userName, redirecting to LogoutServlet");
            response.sendRedirect(request.getContextPath() + "/LogoutServlet?message=Session Expired! Please login again.");
            return;
        }

        String action = request.getParameter("action");
        String teamLeaderIdStr = request.getParameter("teamLeaderId");
        String role = request.getParameter("role");

        LOGGER.info("POST parameters - action: " + action + ", teamLeaderId: " + teamLeaderIdStr + ", role: " + role);

        Integer teamLeaderId;
        try {
            teamLeaderId = Integer.parseInt(teamLeaderIdStr);
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid teamLeaderId format: " + teamLeaderIdStr);
            request.setAttribute("message", "Error: Invalid team leader ID format");
            request.setAttribute("alertType", "error");
            doGet(request, response);
            return;
        }

        if (!"TeamLeader".equals(role)) {
            LOGGER.warning("Unauthorized update attempt by role: " + role);
            request.setAttribute("message", "Error: Unauthorized update");
            request.setAttribute("alertType", "error");
            doGet(request, response);
            return;
        }

        if ("changePassword".equals(action)) {
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");

            LOGGER.info("Change password request - newPassword: [" + (newPassword != null ? "provided" : "null") + "]");

            StringBuilder errorMessage = new StringBuilder();
            if (newPassword == null || newPassword.isEmpty()) {
                errorMessage.append("New password is required. ");
            } else if (newPassword.length() < 8) {
                errorMessage.append("Password must be at least 8 characters long. ");
            }
            if (confirmPassword == null || !confirmPassword.equals(newPassword)) {
                errorMessage.append("Passwords do not match. ");
            }

            if (errorMessage.length() > 0) {
                LOGGER.warning("Password validation failed: " + errorMessage.toString());
                request.setAttribute("message", "Error: " + errorMessage.toString());
                request.setAttribute("alertType", "error");
                doGet(request, response);
                return;
            }

            try (Connection conn = DbConnection.getConnection()) {
                if (conn == null) {
                    LOGGER.severe("Failed to get database connection");
                    request.setAttribute("message", "Error: Database connection failed");
                    request.setAttribute("alertType", "error");
                    doGet(request, response);
                    return;
                }

                String sql = "UPDATE team_leader SET password = ? WHERE teamleader_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, PasswordHashing.hashPassword(newPassword));
                stmt.setInt(2, teamLeaderId);

                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    request.setAttribute("message", "Password changed successfully");
                    request.setAttribute("alertType", "success");
                    LOGGER.info("Password updated for teamLeaderId: " + teamLeaderId);
                } else {
                    request.setAttribute("message", "Error: Password change failed");
                    request.setAttribute("alertType", "error");
                    LOGGER.warning("No rows updated for teamLeaderId: " + teamLeaderId);
                }
            } catch (SQLException e) {
                LOGGER.severe("Error updating password for teamLeaderId: " + teamLeaderId + ": " + e.getMessage());
                request.setAttribute("message", "Error updating password: " + e.getMessage());
                request.setAttribute("alertType", "error");
            }

            doGet(request, response);
            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String mobileNumber = request.getParameter("mobile_number");
        String bio = request.getParameter("bio");
        String address = request.getParameter("address");
        String skills = request.getParameter("skills");
        String dob = request.getParameter("dob");

        LOGGER.info("Raw POST parameters - name: [" + name + "], email: [" + email + "]");

        if (name == null || email == null) {
            LOGGER.warning("Name or email is null, attempting to parse from parts");
            try {
                Part namePart = request.getPart("name");
                Part emailPart = request.getPart("email");
                if (namePart != null) {
                    name = new String(namePart.getInputStream().readAllBytes()).trim();
                }
                if (emailPart != null) {
                    email = new String(emailPart.getInputStream().readAllBytes()).trim();
                }
                LOGGER.info("Parsed from parts - name: [" + name + "], email: [" + email + "]");
            } catch (Exception e) {
                LOGGER.severe("Error parsing name/email from parts: " + e.getMessage());
            }
        }

        StringBuilder errorMessage = new StringBuilder();
        if (name == null || name.trim().isEmpty()) {
            errorMessage.append("Name is required. ");
        }
        if (email == null || email.trim().isEmpty() || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            errorMessage.append("A valid email is required. ");
        }
        if (mobileNumber != null && !mobileNumber.trim().isEmpty() && !mobileNumber.matches("\\d{10}")) {
            errorMessage.append("Mobile number must be 10 digits. ");
        }

        if (errorMessage.length() > 0) {
            LOGGER.warning("Validation failed: " + errorMessage.toString());
            request.setAttribute("message", "Error: " + errorMessage.toString());
            request.setAttribute("alertType", "error");
            doGet(request, response);
            return;
        }

        LOGGER.info("POST parameters after validation - teamLeaderId: " + teamLeaderIdStr + ", role: " + role +
                    ", name: " + name + ", email: " + email);

        String profilePicturePath = null;
        Part filePart = request.getPart("profile_picture");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extractFileName(filePart);
            if (!fileName.matches(".*\\.(jpg|jpeg|png|gif)$")) {
                LOGGER.warning("Invalid file type for profile picture: " + fileName);
                request.setAttribute("message", "Error: Only JPG, PNG, or GIF files are allowed");
                request.setAttribute("alertType", "error");
                doGet(request, response);
                return;
            }
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            profilePicturePath = UPLOAD_DIR + File.separator + teamLeaderId + "_" + fileName;
            filePart.write(uploadPath + File.separator + teamLeaderId + "_" + fileName);
            LOGGER.info("Profile picture uploaded to: " + profilePicturePath);
        }

        if (mobileNumber != null && !mobileNumber.trim().isEmpty()) {
            try (Connection conn = DbConnection.getConnection()) {
                if (conn != null) {
                    String deleteSql = "DELETE FROM mobile_numbers WHERE role_type = 'TeamLeader' AND role_id = ?";
                    try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                        deleteStmt.setInt(1, teamLeaderId);
                        deleteStmt.executeUpdate();
                    }
                    String insertSql = "INSERT INTO mobile_numbers (mobile_number, role_type, role_id) VALUES (?, 'TeamLeader', ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setString(1, mobileNumber);
                        insertStmt.setInt(2, teamLeaderId);
                        insertStmt.executeUpdate();
                        LOGGER.info("Updated mobile number for teamLeaderId: " + teamLeaderId);
                    }
                }
            } catch (SQLException e) {
                LOGGER.severe("Error updating mobile_numbers for teamLeaderId: " + teamLeaderId + ": " + e.getMessage());
            }
        }

        try (Connection conn = DbConnection.getConnection()) {
            if (conn == null) {
                LOGGER.severe("Failed to get database connection");
                request.setAttribute("message", "Error: Database connection failed");
                request.setAttribute("alertType", "error");
                doGet(request, response);
                return;
            }

            String sql = "UPDATE team_leader SET name = ?, email = ?, bio = ?, address = ?, " +
                         (profilePicturePath != null ? "profile_picture = ?, " : "") +
                         "skills = ?, dob = ? WHERE teamleader_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            int paramIndex = 1;
            stmt.setString(paramIndex++, name);
            stmt.setString(paramIndex++, email);
            stmt.setString(paramIndex++, bio != null ? bio : "");
            stmt.setString(paramIndex++, address != null ? address : "");
            if (profilePicturePath != null) {
                stmt.setString(paramIndex++, profilePicturePath);
            }
            stmt.setString(paramIndex++, skills != null ? skills : "");
            stmt.setString(paramIndex++, dob != null && !dob.isEmpty() ? dob : null);
            stmt.setInt(paramIndex, teamLeaderId);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("message", "Profile updated successfully");
                request.setAttribute("alertType", "success");
                LOGGER.info("Profile updated for teamLeaderId: " + teamLeaderId);
            } else {
                request.setAttribute("message", "Error: Profile update failed");
                request.setAttribute("alertType", "error");
                LOGGER.warning("No rows updated for teamLeaderId: " + teamLeaderId);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error updating profile for teamLeaderId: " + teamLeaderId + ": " + e.getMessage());
            request.setAttribute("message", "Error updating profile: " + e.getMessage());
            request.setAttribute("alertType", "error");
        }

        doGet(request, response);
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}