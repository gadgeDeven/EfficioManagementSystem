document.addEventListener('DOMContentLoaded', function() {
    const toggleSidebar = document.getElementById('toggleSidebar');
    const notificationBell = document.getElementById('notificationBell');
    const notificationPanel = document.getElementById('notificationPanel');
    const closeNotification = document.getElementById('closeNotification');
    const notificationDot = document.getElementById('notificationDot');
    const profileIcon = document.getElementById('profileIcon');
    const profileDropdown = document.getElementById('profileDropdown');
    const pageTitle = document.getElementById('pageTitle');
    const dashboardInner = document.getElementById('dashboardInner');

    // Mapping of contentType to title and icon
    const contentTypeMap = {
        'welcome': { title: 'Dashboard', icon: 'fas fa-tachometer-alt' },
        'view-employees': { title: 'View Employees', icon: 'fas fa-users' },
        'employee-profile': { title: 'Employee Profile', icon: 'fas fa-users' },
        'view-teamleaders': { title: 'View Team Leaders', icon: 'fas fa-user-tie' },
        'teamleader-profile': { title: 'Team Leader Profile', icon: 'fas fa-user-tie' },
        'create-projects': { title: 'Create Projects', icon: 'fas fa-folder-plus' },
        'view-projects': { title: 'View Projects', icon: 'fas fa-eye' },
        'assign-team-leaders': { title: 'Assign Team Leaders', icon: 'fas fa-user-tie' },
        'project-team-leaders': { title: 'Project Team Leaders', icon: 'fas fa-project-diagram' },
        'adminsList': { title: 'Admins List', icon: 'fas fa-user-shield' },
        'projectsList': { title: 'All Projects', icon: 'fas fa-project-diagram' },
        'pendingList': { title: 'Pending Projects', icon: 'fas fa-tasks' },
        'completedList': { title: 'Completed Projects', icon: 'fas fa-check-circle' },
        'productivityList': { title: 'Productivity', icon: 'fas fa-chart-line' },
        'notifications': { title: 'Pending Requests', icon: 'fas fa-bell' }
    };

    // Function to update page title based on contentType
    function updatePageTitle(contentType) {
        const { title, icon } = contentTypeMap[contentType] || { title: 'Dashboard', icon: 'fas fa-tachometer-alt' };
        pageTitle.innerHTML = `<i class="${icon}"></i> ${title}`;
    }

    // Initialize page title based on current contentType
    updatePageTitle(currentContentType);

    if (toggleSidebar) {
        toggleSidebar.addEventListener('click', function(e) {
            e.preventDefault();
            const sidebar = document.querySelector('.sidebar');
            const mainContent = document.querySelector('.main-content');
            const topbar = document.querySelector('.topbar');
            sidebar.classList.toggle('closed');
            const isClosed = sidebar.classList.contains('closed');
            mainContent.style.marginLeft = isClosed ? '80px' : '250px';
            topbar.style.left = isClosed ? '80px' : '250px';
        });
    }

    if (notificationBell && notificationPanel && closeNotification) {
        notificationBell.addEventListener('click', function(e) {
            e.preventDefault();
            const isVisible = notificationPanel.style.display === 'block';
            if (!isVisible) {
                dashboardInner.style.display = 'none';
                notificationPanel.style.display = 'block';
                updatePageTitle('notifications');
                fetch(contextPath + '/MarkAsSeenServlet')
                    .then(() => {
                        if (notificationDot) notificationDot.style.display = 'none';
                    })
                    .catch(error => console.error('Error marking as seen:', error));
            } else {
                notificationPanel.style.display = 'none';
                dashboardInner.style.display = 'block';
                updatePageTitle(currentContentType); // Restore original title
            }
        });

        closeNotification.addEventListener('click', function() {
            notificationPanel.style.display = 'none';
            dashboardInner.style.display = 'block';
            updatePageTitle(currentContentType); // Restore original title
        });

        document.addEventListener('click', function(e) {
            // Only handle clicks outside notification panel and bell
            if (!notificationPanel.contains(e.target) && !notificationBell.contains(e.target)) {
                if (notificationPanel.style.display === 'block') {
                    notificationPanel.style.display = 'none';
                    dashboardInner.style.display = 'block';
                    updatePageTitle(currentContentType); // Restore original title
                }
            }
            // Prevent resetting title for clicks on main content or empty areas
            if (e.target === document.body || e.target === document.querySelector('.main-content') || e.target === dashboardInner) {
                e.preventDefault();
                // Do nothing to preserve current title
            }
        });
    }

    if (profileIcon && profileDropdown) {
        profileIcon.addEventListener('click', function(e) {
            e.stopPropagation();
            profileDropdown.style.display = profileDropdown.style.display === 'block' ? 'none' : 'block';
        });

        document.addEventListener('click', function(e) {
            if (!profileIcon.contains(e.target) && !profileDropdown.contains(e.target)) {
                profileDropdown.style.display = 'none';
            }
        });
    }
});