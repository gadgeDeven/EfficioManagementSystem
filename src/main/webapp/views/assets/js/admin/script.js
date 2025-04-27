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

    // Debug: Check if elements are found
    console.log('notificationBell:', notificationBell);
    console.log('notificationPanel:', notificationPanel);
    console.log('closeNotification:', closeNotification);

    // Mapping of contentType to title and icon for Team Leader Dashboard
    const contentTypeMap = {
        'welcome': { title: 'Dashboard', icon: 'fas fa-tachometer-alt' },
        'projects': { title: 'Projects', icon: 'fas fa-project-diagram' },
        'pending-projects': { title: 'Pending Projects', icon: 'fas fa-project-diagram' },
        'completed-projects': { title: 'Completed Projects', icon: 'fas fa-project-diagram' },
        'tasks': { title: 'Tasks', icon: 'fas fa-tasks' },
        'pending-tasks': { title: 'Pending Tasks', icon: 'fas fa-tasks' },
        'completed-tasks': { title: 'Completed Tasks', icon: 'fas fa-tasks' },
        'create-task': { title: 'Create Task', icon: 'fas fa-plus-circle' },
        'assign-task': { title: 'Assign Task', icon: 'fas fa-user-check' },
        'assign-projects': { title: 'Assign Projects', icon: 'fas fa-user-plus' },
        'team-members': { title: 'Team Members', icon: 'fas fa-users' },
        'notifications': { title: 'Notifications', icon: 'fas fa-bell' },
        'project-details': { title: 'Project Details', icon: 'fas fa-project-diagram' },
        'employee-details': { title: 'Employee Details', icon: 'fas fa-user' },
        'task-details': { title: 'Task Details', icon: 'fas fa-tasks' },
        'edit-task': { title: 'Edit Task', icon: 'fas fa-edit' },
        'tasks-by-project': { title: 'Tasks by Project', icon: 'fas fa-tasks' },
        'profile': { title: 'Profile', icon: 'fas fa-user' },
        'settings': { title: 'Settings', icon: 'fas fa-cog' }
    };

    // Function to update page title based on contentType
    function updatePageTitle(contentType) {
        const { title, icon } = contentTypeMap[contentType] || { title: 'Dashboard', icon: 'fas fa-tachometer-alt' };
        pageTitle.innerHTML = `<i class="${icon}"></i> ${title}`;
    }

    // Initialize page title based on current contentType
    updatePageTitle(currentContentType);

    // Initialize notification panel as hidden
    if (notificationPanel) {
        notificationPanel.style.display = 'none';
        notificationPanel.classList.remove('active');
    } else {
        console.error('notificationPanel not found');
    }

    // Sidebar toggle
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

    // Notification panel toggle
    if (notificationBell && notificationPanel) {
        notificationBell.addEventListener('click', function(e) {
            e.preventDefault();
            console.log('Notification bell clicked');
            const isVisible = notificationPanel.style.display === 'block';
            if (!isVisible) {
                dashboardInner.style.display = 'none';
                notificationPanel.style.display = 'block';
                notificationPanel.classList.add('active');
                updatePageTitle('notifications');
                fetch(contextPath + '/MarkAsSeenServlet')
                    .then(() => {
                        if (notificationDot) notificationDot.style.display = 'none';
                    })
                    .catch(error => console.error('Error marking as seen:', error));
            } else {
                notificationPanel.style.display = 'none';
                notificationPanel.classList.remove('active');
                dashboardInner.style.display = 'block';
                updatePageTitle(currentContentType);
            }
        });
    } else {
        console.error('notificationBell or notificationPanel missing');
    }

    // Close notification panel
    if (closeNotification) {
        closeNotification.addEventListener('click', function() {
            console.log('Close notification clicked');
            notificationPanel.style.display = 'none';
            notificationPanel.classList.remove('active');
            dashboardInner.style.display = 'block';
            updatePageTitle(currentContentType);
        });
    } else {
        console.warn('closeNotification not found');
    }

    // Close panel on outside click
    if (notificationPanel) {
        document.addEventListener('click', function(e) {
            if (!notificationPanel.contains(e.target) && !notificationBell.contains(e.target)) {
                if (notificationPanel.style.display === 'block') {
                    console.log('Outside click, closing panel');
                    notificationPanel.style.display = 'none';
                    notificationPanel.classList.remove('active');
                    dashboardInner.style.display = 'block';
                    updatePageTitle(currentContentType);
                }
            }
        });
    }

    // Profile dropdown toggle
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