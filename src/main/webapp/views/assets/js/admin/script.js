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

    if (toggleSidebar) {
        toggleSidebar.addEventListener('click', function(e) {
            e.preventDefault();
            const sidebar = document.querySelector('.sidebar');
            const mainContent = document.querySelector('.main-content');
            const topbar = document.querySelector('.topbar');
            sidebar.classList.toggle('closed');
            const isClosed = sidebar.classList.contains('closed');
            mainContent.style.marginLeft = isClosed ? "80px" : "250px";
            topbar.style.left = isClosed ? "80px" : "250px";
        });
    }

    if (notificationBell && notificationPanel && closeNotification) {
        notificationBell.addEventListener('click', function(e) {
            e.preventDefault();
            const isVisible = notificationPanel.style.display === "block";
            if (!isVisible) {
                dashboardInner.style.display = "none";
                notificationPanel.style.display = "block";
                pageTitle.innerHTML = '<i class="fas fa-bell"></i> Pending Requests';
                fetch(contextPath + '/MarkAsSeenServlet')
                    .then(() => {
                        if (notificationDot) notificationDot.style.display = "none";
                    })
                    .catch(error => console.error('Error marking as seen:', error));
            } else {
                notificationPanel.style.display = "none";
                dashboardInner.style.display = "block";
                pageTitle.innerHTML = '<i class="fas fa-tachometer-alt"></i> Dashboard';
            }
        });

        closeNotification.addEventListener('click', function() {
            notificationPanel.style.display = "none";
            dashboardInner.style.display = "block";
            pageTitle.innerHTML = '<i class="fas fa-tachometer-alt"></i> Dashboard';
        });

        document.addEventListener('click', function(e) {
            if (!notificationPanel.contains(e.target) && !notificationBell.contains(e.target)) {
                notificationPanel.style.display = "none";
                dashboardInner.style.display = "block";
                pageTitle.innerHTML = '<i class="fas fa-tachometer-alt"></i> Dashboard';
            }
        });
    }

    if (profileIcon && profileDropdown) {
        profileIcon.addEventListener('click', function(e) {
            e.stopPropagation();
            profileDropdown.style.display = profileDropdown.style.display === "block" ? "none" : "block";
        });

        document.addEventListener('click', function(e) {
            if (!profileIcon.contains(e.target) && !profileDropdown.contains(e.target)) {
                profileDropdown.style.display = "none";
            }
        });
    }
});