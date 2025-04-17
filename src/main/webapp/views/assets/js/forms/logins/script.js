// Password Eye Toggle Function
function togglePassword() {
    const passwordInput = document.getElementById("password");
    const toggleIcon = document.getElementById("toggleIcon");

    if (!toggleIcon) {
        console.error("Toggle icon element not found!");
        return;
    }

    if (passwordInput.type === "password") {
        passwordInput.type = "text";
        toggleIcon.classList.remove("fa-eye");
        toggleIcon.classList.add("fa-eye-slash");
    } else {
        passwordInput.type = "password";
        toggleIcon.classList.remove("fa-eye-slash");
        toggleIcon.classList.add("fa-eye");
    }
}

// Client-side Validation before submit
function validateForm() {
    const role = document.getElementById("role").value.trim();
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value.trim();
    const errorMessage = document.getElementById("error-message");

    if (!errorMessage) {
        console.error("Error message element not found!");
        return false; // Prevent form submission if element is missing
    }

    errorMessage.innerText = ""; // Clear previous message

    if (role === "") {
        errorMessage.innerText = "Please select your role.";
        return false;
    }
    if (email === "") {
        errorMessage.innerText = "Email cannot be empty.";
        return false;
    }
    if (password === "") {
        errorMessage.innerText = "Password cannot be empty.";
        return false;
    }
    return true; // Allow form submission if all validations pass
}