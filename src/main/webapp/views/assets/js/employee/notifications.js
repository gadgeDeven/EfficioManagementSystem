document.addEventListener('DOMContentLoaded', function() {
    const notificationBell = document.getElementById('notificationBell');
    const notificationPanel = document.getElementById('notificationPanel');
    const notificationDot = document.getElementById('notificationDot');

    if (notificationBell && notificationPanel) {
        notificationBell.addEventListener('click', function() {
            notificationPanel.style.display = notificationPanel.style.display === 'block' ? 'none' : 'block';
        });

        // Close panel when clicking outside
        document.addEventListener('click', function(event) {
            if (!notificationPanel.contains(event.target) && !notificationBell.contains(event.target)) {
                notificationPanel.style.display = 'none';
            }
        });
    }

    // Update notification dot based on unseen count
    function updateNotificationDot() {
        const unseenCount = <%= request.getAttribute("unseenNotifications") != null ? request.getAttribute("unseenNotifications") : 0 %>;
        if (notificationDot) {
            notificationDot.style.display = unseenCount > 0 ? 'block' : 'none';
        }
    }

    updateNotificationDot();

    // Handle form submission via AJAX to mark tasks as seen
    const markSeenForms = document.querySelectorAll('.mark-seen-form');
    markSeenForms.forEach(form => {
        form.addEventListener('submit', function(event) {
            event.preventDefault();
            const formData = new FormData(form);
            fetch(form.action, {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    form.parentElement.remove(); // Remove notification item
                    const remainingItems = document.querySelectorAll('.notification-item').length;
                    if (remainingItems === 0) {
                        document.querySelector('.notification-list').innerHTML = 
                            '<p class="no-notifications"><i class="fas fa-info-circle"></i> No new notifications.</p>';
                        notificationDot.style.display = 'none';
                    }
                } else {
                    alert('Failed to mark task as seen: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error marking task as seen:', error);
                alert('An error occurred while marking the task as seen.');
            });
        });
    });
});