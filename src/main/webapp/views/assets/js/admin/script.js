document.addEventListener('DOMContentLoaded', function() {
    // Use window.contextPath set by EmployeeDashboard.jsp
    const contextPath = window.contextPath || '';
    const currentContentType = window.currentContentType || 'welcome';

    const toggleSidebar = document.getElementById('toggleSidebar');
    const notificationBell = document.getElementById('notificationBell');
    const notificationPanel = document.getElementById('notificationPanel');
    const closeNotification = document.getElementById('closeNotification');
    const notificationDot = document.getElementById('notificationDot');
    const profileIcon = document.getElementById('profileIcon');
    const profileDropdown = document.getElementById('profileDropdown');
    const pageTitle = document.getElementById('pageTitle');
    const dashboardInner = document.getElementById('dashboardInner');

    // Debug: Check elements
    console.log('contextPath:', contextPath);
    console.log('currentContentType:', currentContentType);
    console.log('notificationBell:', notificationBell);
    console.log('notificationPanel:', notificationPanel);
    console.log('closeNotification:', closeNotification);
    console.log('profileIcon:', profileIcon);
    console.log('profileDropdown:', profileDropdown);

    // Content type mapping
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
        'settings': { title: 'Settings', icon: 'fas fa-cog' },
        'calendar': { title: 'Calendar', icon: 'fas fa-calendar' } // Added for calendar
    };

    // Function to update page title
    function updatePageTitle(contentType) {
        const { title, icon } = contentTypeMap[contentType] || { title: 'Dashboard', icon: 'fas fa-tachometer-alt' };
        if (pageTitle) {
            pageTitle.innerHTML = `<i class="${icon}"></i> ${title}`;
        }
    }

    // Initialize page title
    updatePageTitle(currentContentType);

    // Initialize notification panel
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

    // Event delegation for notification and profile
    document.addEventListener('click', function(e) {
        const bell = e.target.closest('#notificationBell');
        const profile = e.target.closest('#profileIcon');

        if (bell && notificationPanel && dashboardInner) {
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
        }

        if (profile && profileDropdown) {
            console.log('Profile icon clicked');
            profileDropdown.style.display = profileDropdown.style.display === 'block' ? 'none' : 'block';
        }

        // Close panels on outside click
        if (!bell && !profile && !e.target.closest('.notification-panel') && !e.target.closest('.dropdown-content')) {
            if (notificationPanel && notificationPanel.style.display === 'block') {
                console.log('Outside click, closing notification panel');
                notificationPanel.style.display = 'none';
                notificationPanel.classList.remove('active');
                dashboardInner.style.display = 'block';
                updatePageTitle(currentContentType);
            }
            if (profileDropdown && profileDropdown.style.display === 'block') {
                console.log('Outside click, closing profile dropdown');
                profileDropdown.style.display = 'none';
            }
        }
    });

    // Close notification panel (if closeNotification exists)
    if (closeNotification) {
        closeNotification.addEventListener('click', function() {
            console.log('Close notification clicked');
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


       const contextPath = '<%=request.getContextPath()%>';
       const currentContentType = '<%=contentType%>';
       console.log('admin-dashboard.jsp: currentContentType=', '<%=contentType%>');
       // Debug: Log when pageTitle changes
       window.addEventListener('DOMContentLoaded', () => {
           const pageTitle = document.getElementById('pageTitle');
           console.log('Initial pageTitle:', pageTitle.innerHTML);
           // Monitor changes to pageTitle
           const observer = new MutationObserver((mutations) => {
               mutations.forEach((mutation) => {
                   console.log('pageTitle changed to:', pageTitle.innerHTML);
               });
           });
           observer.observe(pageTitle, { childList: true, subtree: true });
       });
