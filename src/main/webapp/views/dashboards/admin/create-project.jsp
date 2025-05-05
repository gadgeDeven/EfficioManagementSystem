<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, in.efficio.model.TeamLeader, in.efficio.dao.TeamLeaderDAO" %>
<html>
<head>
    <title>Create Project</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/admin/create-project.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body>
    <div class="create-project-container">
        <form action="${pageContext.request.contextPath}/Projects" method="post" id="createProjectForm">
            <input type="hidden" name="action" value="createProject">
            <div class="form-group">
                <label><i class="fas fa-project-diagram"></i> Project Name:</label>
                <input type="text" name="projectName" required>
            </div>
            <div class="form-group">
                <label><i class="fas fa-align-left"></i> Description:</label>
                <textarea name="description" required></textarea>
            </div>
            <div class="form-group">
                <label><i class="fas fa-calendar-alt"></i> Start Date:</label>
                <input type="date" name="startDate" class="date-input" required>
            </div>
            <div class="form-group">
                <label><i class="fas fa-calendar-check"></i> End Date:</label>
                <input type="date" name="endDate" class="date-input" required>
            </div>
            <div class="form-group">
                <label><i class="fas fa-exclamation-circle"></i> Priority:</label>
                <select name="priority">
                    <option value="High">High</option>
                    <option value="Medium">Medium</option>
                    <option value="Low">Low</option>
                </select>
            </div>
            <div class="form-group">
                <label><i class="fas fa-user-tie"></i> Assign Team Leaders (Optional):</label>
                <div class="teamleader-container">
                    <div class="selected-teamleaders" id="selectedTeamLeaders">
                        <span class="no-teamleaders">No team leaders selected</span>
                    </div>
                    <select id="teamLeaderSelect" class="teamleader-select">
                        <option value="" disabled selected>Select a Team Leader</option>
                        <%
                            TeamLeaderDAO teamLeaderDAO = new TeamLeaderDAO();
                            List<TeamLeader> teamLeaders = teamLeaderDAO.getAllTeamLeaders();
                            for (TeamLeader tl : teamLeaders) {
                                String name = tl.getName() != null && !tl.getName().trim().isEmpty() ? tl.getName().trim() : "TL_" + tl.getTeamleader_id();
                                String safeName = name.replace("\"", "&quot;"); // Escape quotes for HTML
                        %>
                        <option value="<%= tl.getTeamleader_id() %>" data-name="<%= safeName %>">
                            <%= safeName %>
                        </option>
                        <% } %>
                    </select>
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn"><i class="fas fa-plus-circle"></i> Create Project</button>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const select = document.getElementById('teamLeaderSelect');
            const selectedTeamLeadersDiv = document.getElementById('selectedTeamLeaders');
            const form = document.getElementById('createProjectForm');
            const selectedTeamLeaders = new Set();

            // Handle team leader selection
            select.addEventListener('change', function () {
                const option = select.options[select.selectedIndex];
                const id = option.value;
                const name = option.getAttribute('data-name')?.trim();
                console.log('Selected Team Leader: ID=', id, 'Name=', name); // Debug log
                if (!id || selectedTeamLeaders.has(id) || !name) return;

                // Add to selected set
                selectedTeamLeaders.add(id);

                // Remove "No team leaders selected" message
                const noTeamLeaders = selectedTeamLeadersDiv.querySelector('.no-teamleaders');
                if (noTeamLeaders) noTeamLeaders.remove();

                // Create tag
                const tag = document.createElement('div');
                tag.className = 'teamleader-tag';
                tag.dataset.id = id;
                tag.style.opacity = '0';
                tag.style.transform = 'translateY(10px)';
                tag.innerHTML = `
                    <span class="teamleader-name"><i class="fas fa-user-tie"></i> ${name}</span>
                    <span class="remove-teamleader" data-id="${id}"><i class="fas fa-times-circle"></i></span>
                `;
                selectedTeamLeadersDiv.appendChild(tag);

                // Animate tag appearance
                setTimeout(() => {
                    tag.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                    tag.style.opacity = '1';
                    tag.style.transform = 'translateY(0)';
                }, 10);

                // Add hidden input
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'teamLeaderIds';
                input.value = id;
                input.dataset.id = id;
                form.appendChild(input);

                // Reset select to default
                select.value = '';
            });

            // Handle team leader removal
            selectedTeamLeadersDiv.addEventListener('click', function (e) {
                const removeButton = e.target.closest('.remove-teamleader');
                if (removeButton) {
                    const id = removeButton.dataset.id;
                    const tag = removeButton.closest('.teamleader-tag');
                    console.log('Removing Team Leader: ID=', id); // Debug log

                    // Animate tag removal
                    tag.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                    tag.style.opacity = '0';
                    tag.style.transform = 'translateY(10px)';

                    setTimeout(() => {
                        // Remove from selected set
                        selectedTeamLeaders.delete(id);

                        // Remove tag
                        tag.remove();

                        // Remove hidden input
                        const inputs = form.querySelectorAll(`input[name="teamLeaderIds"][data-id="${id}"]`);
                        inputs.forEach(input => input.remove());

                        // Show "No team leaders selected" if empty
                        if (selectedTeamLeaders.size === 0) {
                            const noTeamLeaders = document.createElement('span');
                            noTeamLeaders.className = 'no-teamleaders';
                            noTeamLeaders.textContent = 'No team leaders selected';
                            selectedTeamLeadersDiv.appendChild(noTeamLeaders);
                        }
                    }, 300);
                }
            });

            // Prevent date inputs from auto-opening
            const dateInputs = document.querySelectorAll('input[type="date"]');
            dateInputs.forEach(input => {
                input.addEventListener('click', function (e) {
                    if (e.target !== input) return;
                    input.showPicker?.();
                });
            });

            // Debug form submission
            form.addEventListener('submit', function (e) {
                console.log('Form submitted with teamLeaderIds:', Array.from(selectedTeamLeaders));
            });
        });
    </script>
</body>
</html>