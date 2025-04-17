document.addEventListener('DOMContentLoaded', function() {
    // Menu Toggle
    const toggleSidebar = document.getElementById('toggleSidebar');
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('mainContent');

    if (toggleSidebar && sidebar && mainContent) {
        toggleSidebar.addEventListener('click', function(e) {
            e.preventDefault();
            sidebar.classList.toggle('closed'); // Match CSS class
            mainContent.classList.toggle('expanded');
        });
    }

    // Notification Panel Toggle (Eye Button)
    const notificationBell = document.getElementById('notificationBell');
    const notificationPanel = document.getElementById('notificationPanel');
    const dashboardInner = document.getElementById('dashboardInner');
    const closeNotification = document.querySelector('.close-btn'); // Notification close button

    if (notificationBell && notificationPanel && dashboardInner) {
        notificationBell.addEventListener('click', function(e) {
            e.preventDefault();
            const isPanelVisible = notificationPanel.style.display === 'block';
            notificationPanel.style.display = isPanelVisible ? 'none' : 'block';
            dashboardInner.style.display = isPanelVisible ? 'block' : 'none';
            const notificationDot = document.getElementById('notificationDot');
            if (notificationDot && !isPanelVisible) {
                notificationDot.style.display = 'none';
            }
            notificationPanel.style.opacity = isPanelVisible ? '0' : '1';
        });

        // Close Notification Panel
        if (closeNotification) {
            closeNotification.addEventListener('click', function(e) {
                e.preventDefault();
                notificationPanel.style.display = 'none';
                dashboardInner.style.display = 'block';
                notificationPanel.style.opacity = '0';
            });
        }
    }

    // Profile Dropdown Toggle
    const profileIcon = document.getElementById('profileIcon');
    const profileDropdown = document.getElementById('profileDropdown');

    if (profileIcon && profileDropdown) {
        profileIcon.addEventListener('click', function(e) {
            e.preventDefault();
            const isDropdownVisible = profileDropdown.style.display === 'block';
            profileDropdown.style.display = isDropdownVisible ? 'none' : 'block';
            profileDropdown.style.opacity = isDropdownVisible ? '0' : '1';
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!profileIcon.contains(e.target) && !profileDropdown.contains(e.target)) {
                profileDropdown.style.display = 'none';
                profileDropdown.style.opacity = '0';
            }
        });
    }

    // Prevent pageTitle from resetting on hover
    const pageTitle = document.getElementById('pageTitle');
    if (pageTitle) {
        pageTitle.addEventListener('mouseover', function(e) {
            // Do nothing to preserve current title
        });
    }
});