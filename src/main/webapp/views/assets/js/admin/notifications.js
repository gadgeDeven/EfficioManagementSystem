function handleAction(id, role, status) {
    fetch(`${contextPath}/ApproveRejectServlet?id=${id}&role=${role}&status=${status}`)
        .then(response => {
            if (!response.ok) throw new Error('Action failed');
            const row = document.getElementById(`notification_${id}`);
            if (row) row.remove();

            const tableBody = document.getElementById('notificationTable');
            if (tableBody.querySelectorAll('tr').length === 0) {
                tableBody.innerHTML = '<tr><td colspan="7">No pending requests.</td></tr>';
            }
        })
        .catch(error => console.error('Error performing action:', error));
}