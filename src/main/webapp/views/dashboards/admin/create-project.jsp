<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create Project</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/create-project.css"> 
</head>
<body>
    <div class="create-project-container">

        <form action="${pageContext.request.contextPath}/Projects" method="post">
            <input type="hidden" name="action" value="createProject">
            <div class="form-group">
               <label> <i class="fas fa-project-diagram"></i> Project Name:</label>
                <input type="text" name="projectName" required>
            </div>
            <div class="form-group">
                <label><i class="fas fa-info-circle"></i> Description:</label>
                <textarea name="description" required></textarea>
            </div>
            <div class="form-group">
                <label><i class="fas fa-calendar-alt"></i> Start Date:</label>
                <input type="date" name="startDate" required>
            </div>
            <div class="form-group">
                <label><i class="fas fa-calendar-check"></i> End Date:</label>
                <input type="date" name="endDate" required>
            </div>
            <div class="form-group">
                <label><i class="fas fa-exclamation-triangle"></i> Priority:</label>
                <select name="priority">
                    <option value="High">High</option>
                    <option value="Medium">Medium</option>
                    <option value="Low">Low</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn"><i class="fas fa-save"></i> Create Project</button>
            </div>
        </form>
    </div>
</body>
</html>