document.addEventListener('DOMContentLoaded', function() {
    const contextPath = window.contextPath;
    const currentContentType = window.currentContentType;
    const toggleSidebar = document.getElementById('toggleSidebar');
    const notificationBell = document.getElementById('notificationBell');
    const notificationPanel = document.getElementById('notificationPanel');
    const closeNotification = document.getElementById('closeNotification');
    const notificationDot = document.getElementById('notificationDot');
    const profileIcon = document.getElementById('profileIcon');
    const profileDropdown = document.getElementById('profileDropdown');
    const pageTitle = document.getElementById('pageTitle');
    const dashboardInner = document.getElementById('dashboardInner');

    // Function to update page title
    function updatePageTitle(contentType) {
        const { title, icon } = window.contentTypeMap[contentType] || window.contentTypeMap['welcome'];
        if (pageTitle) {
            pageTitle.innerHTML = `<i class="${icon}"></i> ${title}`;
        }
    }

    // Initialize notification panel
    if (notificationPanel) {
        if (currentContentType !== 'notifications') {
            notificationPanel.style.display = 'none';
            notificationPanel.classList.remove('active');
        } else {
            notificationPanel.style.display = 'block';
            notificationPanel.classList.add('active');
            dashboardInner.style.display = 'none';
        }
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

    // Event delegation for notification and profile
    document.addEventListener('click', function(e) {
        const bell = e.target.closest('#notificationBell');
        const profile = e.target.closest('#profileIcon');

        if (bell && notificationPanel && dashboardInner) {
            const isVisible = notificationPanel.style.display === 'block';
            notificationPanel.style.display = isVisible ? 'none' : 'block';
            notificationPanel.classList.toggle('active', !isVisible);
            dashboardInner.style.display = isVisible ? 'block' : 'none';
            updatePageTitle(isVisible ? currentContentType : 'notifications');
            if (!isVisible) {
                fetch(contextPath + '/TeamLeaderMarkAsSeenServlet')
                    .then(() => {
                        if (notificationDot) notificationDot.style.display = 'none';
                    })
                    .catch(error => console.error('Error marking as seen:', error));
            }
        }

        if (profile && profileDropdown) {
            profileDropdown.style.display = profileDropdown.style.display === 'block' ? 'none' : 'block';
        }

        if (!bell && !profile && !e.target.closest('.notification-panel') && !e.target.closest('.dropdown-content')) {
            if (notificationPanel && notificationPanel.style.display === 'block') {
                notificationPanel.style.display = 'none';
                notificationPanel.classList.remove('active');
                dashboardInner.style.display = 'block';
                updatePageTitle(currentContentType);
            }
            if (profileDropdown && profileDropdown.style.display === 'block') {
                profileDropdown.style.display = 'none';
            }
        }
    });

    // Close notification panel
    if (closeNotification) {
        closeNotification.addEventListener('click', function() {
            if (notificationPanel && dashboardInner) {
                notificationPanel.style.display = 'none';
                notificationPanel.classList.remove('active');
                dashboardInner.style.display = 'block';
                updatePageTitle(currentContentType);
            }
        });
    } else {
        console.warn('closeNotification not found');
    }
});