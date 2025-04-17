// employee_list.js

document.addEventListener("DOMContentLoaded", function() {


    // Example: Confirm before deleting an employee
    const deleteButtons = document.querySelectorAll('.delete-btn');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(event) {
            const confirmDelete = confirm("Are you sure you want to delete this employee?");
            if (!confirmDelete) {
                event.preventDefault(); // Prevent form submission
            }
        });
    });
});