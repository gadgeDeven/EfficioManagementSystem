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

// Form Validation Function
function validateForm() {
    let isValid = true;
    const form = document.forms[0];
    const role = form["role"];
    const name = form["name"];
    const email = form["email"];
    const password = form["password"];
    const confirmPassword = form["confirmPassword"];
    const dob = form["dob"];
    const department = form["department"];

    document.querySelectorAll('.error-message').forEach(span => {
        span.style.display = 'none';
        span.innerText = '';
    });

    document.querySelectorAll('input, select, textarea').forEach(input => {
        input.classList.remove('input-error');
    });

    if (role.value.trim() === "") {
        showError(role, "Please select a role.");
        isValid = false;
    }

    if (name.value.trim() === "") {
        showError(name, "Name cannot be empty.");
        isValid = false;
    } else if (name.value.trim().length < 2) {
        showError(name, "Name must be at least 2 characters long.");
        isValid = false;
    }

    const emailPattern = /^[^ ]+@[^ ]+\.[a-z]{2,}$/i;
    if (!emailPattern.test(email.value.trim())) {
        showError(email, "Please enter a valid email address.");
        isValid = false;
    }

    const strongPasswordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$!%*?&])[A-Za-z\d@#$!%*?&]{8,}$/;
    if (!strongPasswordPattern.test(password.value.trim())) {
        showError(password, "Password must be 8+ characters with uppercase, lowercase, number, and special character.");
        isValid = false;
    }

    if (password.value.trim() !== confirmPassword.value.trim()) {
        showError(confirmPassword, "Passwords do not match.");
        isValid = false;
    }

    if (dob.value.trim() === "") {
        showError(dob, "Please select your date of birth.");
        isValid = false;
    } else {
        const today = new Date();
        const birthDate = new Date(dob.value);
        if (birthDate >= today) {
            showError(dob, "Date of birth cannot be today or in the future.");
            isValid = false;
        }
    }

    if (department.value.trim() === "") {
        showError(department, "Please select a department.");
        isValid = false;
    }

    if (!isValid) {
        const formElement = document.querySelector('form');
        formElement.classList.add('shake');
        setTimeout(() => {
            formElement.classList.remove('shake');
        }, 500);
        return false;
    }

    const btn = document.querySelector('input[type="submit"]');
    btn.disabled = true;
    btn.value = "Registering...";
    return true;
}

function showError(inputElement, message) {
    const errorSpan = inputElement.parentElement.querySelector('.error-message');
    if (errorSpan) {
        errorSpan.innerText = message;
        errorSpan.style.display = 'block';
        inputElement.classList.add('input-error');
    } else {
        console.error("Error span not found for input:", inputElement);
    }
}